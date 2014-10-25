scriptId = 'com.coolstuf.bodypartidentify'

-- heart position is more reliable than ear. I found some ears around me in space.
-- works best if you don't turn around.

calibSet = {0,0,0,0,0,0}
partHeart = {0,0,0,0,0,0} 
partEar = {0,0,0,0,0,0}
lowPitch = 4
highPitch = 1
lowRoll = 5
highRoll = 2
lowYaw = 6
highYaw = 3
partsToId = 2
detect = "default"
calibrating = false

myo.debug("place your hand over your heart and make a fist to begin calibrating heart position.")
function onPoseEdge(pose, edge)
	if pose == "fist" then
		if edge == "on" then
			if partsToId > 0 then
				if partsToId == 2 then
					if calibrating == false then
						calibrating = true
						calibSet = {myo.getPitch(),myo.getRoll(),myo.getYaw(),myo.getPitch(),myo.getRoll(),myo.getYaw()}
						myo.debug("move your hand around your heart and make a fist to finish calibration.")
					elseif calibrating == true then
						calibrating = false
						partHeart = calibSet
						partsToId = partsToId - 1
						myo.debug("place your hand over your ear and make a fist to begin calibrating ear position.")
					end
				elseif partsToId == 1 then
					if calibrating == false then
						calibrating = true
						calibSet = {myo.getPitch(),myo.getRoll(),myo.getYaw(),myo.getPitch(),myo.getRoll(),myo.getYaw()}
						myo.debug("move your hand around your ear and make a fist to finish calibration.")
					elseif calibrating == true then
						calibrating = false
						partEar = calibSet
						partsToId = partsToId - 1
						myo.debug("Calibration complete!")
					end
				end
			end
		end
	end
end

function onPeriodic()
	pitch = myo.getPitch()
	roll = myo.getRoll()
	yaw = myo.getYaw()
	if myo.getXDirection() == "towardWrist" then
		pitch = -pitch
		roll = -roll
	end
	if calibrating then
		if pitch > calibSet[highPitch] then
			calibSet[highPitch] = pitch
		elseif pitch < calibSet[lowPitch] then
			calibSet[lowPitch] = pitch
		end
		if roll > calibSet[highRoll] then
			calibSet[highRoll] = roll
		elseif roll < calibSet[lowRoll] then
			calibSet[lowRoll] = roll
		end
		if yaw > calibSet[highYaw] then
			calibSet[highYaw] = yaw
		elseif yaw < calibSet[lowYaw] then
			calibSet[lowYaw] = yaw
		end
	end
	if partsToId == 0 then
		if partHeart[lowPitch] <= pitch and pitch <= partHeart[highPitch] then
			if partHeart[lowRoll] <= roll and roll <= partHeart[highRoll] then
				if partHeart[lowYaw] <= yaw and yaw <= partHeart[highYaw] then
					if detect ~= "heart" then
						detect = "heart"
						--myo.keyboard("left_win","press")
						myo.debug(detect)
					end
				end
			end
		elseif partEar[lowPitch] <= pitch and pitch <= partEar[highPitch] then
			if partEar[lowRoll] <= roll and roll <= partEar[highRoll] then
				if partEar[lowYaw] <= yaw and yaw <= partEar[highYaw] then
					if detect ~= "ear" then
						detect = "ear"
						myo.debug(detect)
					end
				end
			end
		elseif detect ~= "nothing detected" then
			detect = "nothing detected"
			myo.debug(detect)
		end
	end
end

function onForegroundWindowChange(app, title)
    return true
end

function activeAppName()
    return "Find Heart"
end

function onActiveChange(isActive)
end
