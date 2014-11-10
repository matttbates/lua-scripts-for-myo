scriptId = 'com.coolstuf.keyboard'

curDash = 6
curChar = 1
curCase = "lower"
lMorse = {"space","e","i","s","h","5","4","v","space","3","u","f","space","space","space","space","2","a","r","l","space","space","space","space","space","w","p","space","space","j","space","1","t","n","d","b","6","space","x","space","space","k","c","space","space","y","space","space","m","g","z","7","space","q","space","space","o","space","8","space","space","9","0"}
nCase = {"1","2","3","4","5","6","7","8","9","0","minus","equal","comma","period","forwardslash"}

function printChar()
	if curCase == "lower" then
		myo.keyboard(lMorse[curChar],"press")
	elseif curCase == "upper" then
		myo.keyboard(lMorse[curChar],"press","shift")
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

function resetDash()
	curChar = 1
	curDash = 6
	myo.vibrate("short")
end

function dot()
	curDash = curDash - 1
	if curDash > 0 then
		curChar = curChar + 1
	else
		resetDash()
	end
	myo.keyboard("backspace","press")
	printChar()
end

function dash()
	curDash = curDash - 1
	if curDash > 0 then
		curChar = curChar + 2 ^ curDash
	else
		resetDash()
	end
	myo.keyboard("backspace","press")
	printChar()
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
		resetDash()
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
			resetDash()
			printChar()
		end
	end

	if pose == "waveIn" or pose == "waveOut" then
		swapArms()
		if pose == "waveIn" and edge == "on" then
			if curCase == "punc" or curCase == "symbol" then
				prevChar()
			elseif curCase == "lower" or curCase == "upper" then
				dot()
			end
		elseif pose == "waveOut" and edge == "on" then
			if curCase == "punc" or curCase == "symbol" then
				nextChar()
			elseif curCase == "lower" or curCase == "upper" then
				dash()
			end
		end
	end

	if pose == "fingersSpread" then
		if edge == "on" then
			caseChange()
			if curCase == "back" then
				curChar = 1
			end
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
