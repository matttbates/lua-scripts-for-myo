scriptId = 'com.coolstuf.keyboard'

curChar = 1
curCase = "lower"
lCase = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","space"}
nCase = {"1","2","3","4","5","6","7","8","9","0","period","comma","forwardslash","minus","equal"}

function printChar()
	if curCase == "lower" then
		if curChar > 27 then
			curChar = 1
		elseif curChar == 0 then
			curChar = 27
		end
		myo.keyboard(lCase[curChar],"press")
	elseif curCase == "upper" then
		if curChar > 27 then
			curChar = 1
		elseif curChar == 0 then
			curChar = 27
		end
		myo.keyboard(lCase[curChar],"press","shift")
	elseif curCase == "back" then
		myo.keyboard("comma","press","shift")
	elseif curCase == "punc" then
		if curChar > 15 then
			curChar = 1
		elseif curChar == 0 then
			curChar = 15
		end
		myo.keyboard(nCase[curChar],"press")
	elseif curCase == "symbol" then
		if curChar > 15 then
			curChar = 1
		elseif curChar == 0 then
			curChar = 15
		end
		myo.keyboard(nCase[curChar],"press","shift")
	end
end

function nextChar()
	myo.keyboard("backspace","press")
	curChar = curChar + 1
	printChar()
end

function prevChar()
	myo.keyboard("backspace","press")
	curChar = curChar - 1
	printChar()
end

function caseChange()
	if curCase == "lower" then
		curCase = "upper"
	elseif curCase == "upper" then
		curCase = "back"
	elseif curCase == "back" then
		curCase = "punc"
	elseif curCase == "punc" then
		curCase = "symbol"
	elseif curCase == "symbol" then
		curCase = "lower"
	end
	myo.keyboard("backspace","press")
	printChar()
end

function swapArms()
	if myo.getArm() == "left" then
		if pose == "waveIn" then
			pose = "waveOut"
		else
			pose = "waveIn"
		end
	end
end

function onPoseEdge(pose, edge)
	if pose == "fist" then
		if edge == "on" then
			if curCase == "back" then
				myo.keyboard("backspace","press")
				myo.keyboard("backspace","press")
			end
			printChar()
		end
	end

	if pose == "waveIn" or pose == "waveOut" then
		swapArms()
		if pose == "waveIn" and edge == "on" then
			prevChar()
		elseif pose == "waveOut" and edge == "on" then
			nextChar()
		end
	end

	if pose == "fingersSpread" then
		if edge == "on" then
			caseChange()
		end
	end
end

function onPeriodic()
end

function onForegroundWindowChange(app, title)
		return true
end

function activeAppName()
    return "Output Everything"
end

function onActiveChange(isActive)
end
