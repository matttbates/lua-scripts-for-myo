scriptId = 'com.coolstuf.mouse'

-- Effects 

function rightClick()
    	myo.mouse("right", "down")
end

function unRightClick()
    	myo.mouse("right", "up")
end

function leftClick()
    	myo.mouse("left", "click")
end

function middleClick()
	myo.mouse("center", "click")
end

function dragClick()
	myo.mouse("left", "down")
end

function unDragClick()
    	myo.mouse("left", "up")
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
	myo.controlMouse(true)
end

function relock()
	unlocked = false
	myo.controlMouse(false)
end

-- Implement Callbacks 

function onPoseEdge(pose, edge)

-- Unlock
    	if pose == "thumbToPinky" then
		if unlocked == false then
  	    		if edge == "off" then
    	        		unlock()
    	    		elseif edge == "on" then
     	       			myo.vibrate("short")
     	       			myo.vibrate("short")
     	    		end
		elseif unlocked == true then
			if edge == "off" then
    	        		relock()
    	    		elseif edge == "on" then
     	       			myo.vibrate("short")
     	    		end
		end
    	end

-- left button
	if pose == "fingersSpread" then
		if unlocked and edge == "on" then
			leftClick()	
		end
	end
	
-- middle/right click.
    	if pose == "waveIn" or pose == "waveOut" then
		pose = conditionallySwapWave(pose)
        	if unlocked and edge == "on" then
            		if pose == "waveIn" then
                		middleClick()
            		else
                		rightClick()
            		end
             	elseif unlocked and edge == "off" then
            		if pose == "waveOut" then
                		unRightClick()
            		end
        	end
    	end

-- drag click
	if pose == "fist" then
		if unlocked and edge == "on" then
			dragClick()
		elseif unlocked and edge == "off" then
			unDragClick()
		end
	end

end

function onPeriodic()
	if myo.getArm() == "unknown" then
		relock()
	end
end

function onForegroundWindowChange(app, title)
	appName = title
	if myo.getArm() == "unknown" then
		relock()
		return false
	else
		return true
	end
end

function onActiveChange(isActive)
	unlocked = false
end


