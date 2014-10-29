scriptId = 'com.coolstuf.spacial keyboard'

toCalibrate = "fist"
toSelect = "fingersSpread"
keys1 = {"1","2","3","4","5","6","7","8","9","0","minus","equal"}
keys2 = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p","leftbracket","rightbracket"}
keys3 = {"a", "s", "d", "f", "g", "h", "j", "k", "l", "semicolon","quote","space"}
keys4 = {"space", "z", "x", "c", "v", "b", "n", "m", "comma", "period", "forwardslash","space"}
keyBoardWidth = 12
keyBoardHeight = 4
needsCalibrating = true
calibrating = false
inRange = false
calib = {0,0,0,0}
-- {xmin,xmax,ymin,ymax}
curChar = ""
prevChar = ""
highPitch = 4
lowPitch = 3
highYaw = 2
lowYaw = 1
susYaw = myo.getYaw()
keyWidth = 0
keyHeight = 0
myo.debug("Make a fist and move your arm around in front of you.")

function select()
	myo.keyboard("space","press")
	printPreview()
end

function rangeCheck()
	charYaw = (keyBoardWidth + 1) - math.ceil((yaw - calib[lowYaw])/keyWidth)
	charPitch = (keyBoardHeight + 1) - math.ceil((pitch - calib[lowPitch])/keyHeight)
	if charYaw <= keyBoardWidth and charYaw > 0 and charPitch <= keyBoardHeight and charPitch > 0 then
		inRange = true
	else
		inRange = false
	end
end

function charId()
	if charPitch == 1 then
		curChar = keys1[charYaw]
	elseif charPitch == 2 then
		curChar = keys2[charYaw]
	elseif charPitch == 3 then
		curChar = keys3[charYaw]
	elseif charPitch == 4 then
		curChar = keys4[charYaw]
	end
end

function printPreview()
		myo.keyboard("backspace","press")
		myo.keyboard(curChar,"press")
end

function onPoseEdge(pose, edge)
	if pose == toCalibrate then
		if edge == "on" then
			if needsCalibrating == true and calibrating == false then
				calibrating = true
				calib[highPitch] = myo.getPitch()
				calib[lowPitch] = myo.getPitch()
				calib[highYaw] = myo.getYaw()
				calib[lowYaw] = myo.getYaw()
				myo.debug("Calibrating...")
			elseif needsCalibrating == true and calibrating == true then
				calibrating = false
				keyWidth = (calib[highYaw] - calib[lowYaw])/keyBoardWidth
				keyHeight = (calib[highPitch] - calib[lowPitch])/keyBoardHeight
				needsCalibrating = false
				myo.debug("Calibration Successful!")
				myo.debug("Spread your fingers to select a character.")
			end
		end
	end
	if pose == toSelect then
		if edge == "on" then
			if needsCalibrating == false then
				select()
			end
		end
	end
end

function onPeriodic()
	pitch = myo.getPitch()
	yaw = myo.getYaw()
	if myo.getXDirection() == "towardWrist" then
		pitch = -pitch
	end
	if yaw < 0 then
		yaw = (2 * math.pi) + yaw
	end
	if yaw > (susYaw + 5) then
		yaw = yaw - (math.pi * 2)
	elseif yaw < (susYaw - 5) then
		yaw = yaw + (math.pi * 2)
	end
	susYaw = yaw
	if calibrating then
		if pitch > calib[highPitch] then
			calib[highPitch] = pitch
		elseif pitch < calib[lowPitch] then
			calib[lowPitch] = pitch
		end
		if yaw > calib[highYaw] then
			calib[highYaw] = yaw
		elseif yaw < calib[lowYaw] then
			calib[lowYaw] = yaw
		end
	elseif needsCalibrating == false then
		rangeCheck()
		if inRange then
			charId()
			if curChar ~= prevChar then
				prevChar = curChar
				printPreview()
				--myo.vibrate("short")
			end
		elseif curChar ~= "space" then
			curChar = "space"
			prevChar = "space"
			printPreview()
			--myo.vibrate("short")
		end
	end
	
end

function onForegroundWindowChange(app, title)
		return true
end

function onActiveChange(isActive)
	unlocked = false
end
