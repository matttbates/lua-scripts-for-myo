scriptId = 'com.coolstuf.youtube'

-- Effects

function forward()
    	myo.keyboard("right_arrow", "press")
    	myo.keyboard("right_arrow", "press")
end

function backward()
    	myo.keyboard("left_arrow", "press")
    	myo.keyboard("left_arrow", "press")
end

function playPause()
	myo.keyboard("space", "press")
end

function volumeUp()
	myo.keyboard("up_arrow", "press")
end

function volumeDown()
	myo.keyboard("down_arrow", "press")
end

function shuttleBurst()
    if shuttleDirection == "forward" then
        forward()
    elseif shuttleDirection == "backward" then
        backward()
    end
end

function volBurst()
	if volDirection == "up" then
		volumeUp()
	elseif volDirection == "down" then
		volumeDown()
	end
end

-- Helpers

function conditionallySwapWave(pose)
    	if myo.getArm() == "left" then
        	if pose == "waveIn" then
            		pose = "waveOut"
        	elseif pose == "waveOut" then
            		pose = "waveIn"
        	end
    	end
    	return pose
end

-- Unlock mechanism

function unlock()
    	unlocked = true
    	extendUnlock()
end

function relock()
	unlocked = false
end

function extendUnlock()
    	unlockedSince = myo.getTimeMilliseconds()
end

-- Implement Callbacks

function onPoseEdge(pose, edge)

-- Unlock
    	if pose == "thumbToPinky" then
        	if edge == "off" then
            		unlock()
        	elseif edge == "on" and not unlocked then
            		myo.vibrate("short")
            		myo.vibrate("short")
            		extendUnlock()
        	end
    	end

-- Play and pause
	if pose == "fingersSpread" then
		if unlocked and edge == "on" then
			myo.vibrate("short")
			playPause()
			relock()
		end
	end
	
-- Forward/backward.
    	if pose == "waveIn" or pose == "waveOut" then
        	local now = myo.getTimeMilliseconds()

        	if unlocked and edge == "on" then
            		pose = conditionallySwapWave(pose)
            		if pose == "waveIn" then
                		shuttleDirection = "backward"
            		else
                		shuttleDirection = "forward"
            		end
            	myo.vibrate("short")
            	shuttleBurst()
        	end
    	end
	
	if pose == "fist" then
		local now = myo.getTimeMilliseconds()
		yawStart = myo.getYaw()
		if unlocked and edge == "on" then
	    		volSince = now
            		volTimeout = VOL_CONTROL_PERIOD
            		extendUnlock()
		end
		if edge == "off" then
			volTimeout = nil
			relock()
		end
		
	end

end

-- All timeouts in milliseconds.

-- Time since last activity before we lock
UNLOCKED_TIMEOUT = 2500

-- Delay between volume control steps
VOL_CONTROL_PERIOD = 250

function onPeriodic()
    	local now = myo.getTimeMilliseconds()
	local yawNow = myo.getYaw()	
-- Volume change behaviour
    	if volTimeout then
        	extendUnlock()
        	if (now - volSince) > volTimeout then
			if yawNow - yawStart < -0.1 then
				volDirection = "up"
				volBurst()
			elseif yawNow - yawStart > 0.1 then
				volDirection = "down"
				volBurst()
			end
            	volSince = now
        	end
    	end

-- Lock after inactivity
    	if unlocked then
        	if myo.getTimeMilliseconds() - unlockedSince > UNLOCKED_TIMEOUT then
            		unlocked = false
        	end
    	end
end

function onForegroundWindowChange(app, title)
        local wantActive = string.match(title, "YouTube")
        activeApp = "Youtube"
    	return wantActive
end

function activeAppName()
    	return activeApp
end

function onActiveChange(isActive)
    	if not isActive then
        	unlocked = false
    	end
end
