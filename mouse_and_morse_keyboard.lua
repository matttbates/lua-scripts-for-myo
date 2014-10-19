scriptId = 'com.coolstuf.mouse_and_keyboard'

--	This script has 3 modes locked, mouse and keyboard in order. Use thumb to pinky
--	to switch modes. 

--	Locked (medium vibration when locked)

--	Mouse (single vibration when activated)
--		fingersSpread = left click
--		fist = left click and drag
--		wave out = right click(and drag)
--		wave in = scroll click

--	Keyboard (double vibration when activated)
--		The keyboard is based on morse code and has 3 modes of its own. In order they 
--		are lower case, upper case and backspace. When in backspace mode a less than symbol
--		appears. select it to backspace. Note: a preview character will appear as you complete 
--		the dots and dashes. This is only a preview and will not remain unless you select it.
--		When a character is selected or too many dots and dashes were used a single short 
--		vibration will be felt indicating that the character has reset to 1 which is a space.
	
--		fingersSpread = switch modes
--		wave left = dot
--		wave right = dash
--		fist = select 

-- Variables

curDash = 6
curChar = 1
curCase = "lower"
lockMode = "locked"
lMorse = {"space","e","i","s","h","5","4","v","space","3","u","f","space","space","space","space","2","a","r","l","space","space","space","space","space","w","p","space","space","j","space","1","t","n","d","b","6","space","x","space","space","k","c","space","space","y","space","space","m","g","z","7","space","q","space","space","o","space","8","space","space","9","0"}

-- Effects 

-- Morse functions

function printChar()
	if curCase == "lower" then
		myo.keyboard(lMorse[curChar],"press")
	elseif curCase == "upper" then
		myo.keyboard(lMorse[curChar],"press","shift")
	elseif curCase == "back" then
		myo.keyboard("comma","press","shift")
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

function caseChange()
	if curCase == "lower" then
		curCase = "upper"
	elseif curCase == "upper" then
		curCase = "back"
	elseif curCase == "back" then
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

-- Mouse functions

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

-- Unlock mechanism 

function unlock()
    	unlocked = true
	myo.controlMouse(true)
	lockMode = "mouse"
end

function relock()
	unlocked = false
	myo.controlMouse(false)
	lockMode = "locked"
end

-- Implement Callbacks 

function onPoseEdge(pose, edge)

-- Unlock
    	if pose == "thumbToPinky" then
		if unlocked == false and lockMode == "locked" then
  	    		if edge == "off" then
    	        		unlock()
    	    		elseif edge == "on" then
     	       			myo.vibrate("short")
     	    		end
		elseif unlocked == true and lockMode == "mouse" then
			if edge == "off" then
				lockMode = "keyboard"
				myo.controlMouse(false)
			elseif edge == "on" then
				myo.vibrate("short")
     	       			myo.vibrate("short")
			end
		elseif unlocked == true and lockMode == "keyboard" then
			if edge == "off" then
    	        		relock()
    	    		elseif edge == "on" then
     	       			myo.vibrate("medium")
     	    		end
		end
    	end

-- Mouse

	if lockMode == "mouse" then
-- left button
		if pose == "fingersSpread" then
			if unlocked and edge == "on" then
				leftClick()	
			end
		end
	
-- middle click
    		if pose == "waveIn" then 
	        	if unlocked and edge == "on" then
                		middleClick()
        	    	end
		end

-- right click
		if pose == "waveOut" then
                	if unlocked and edge == "on" then	
				rightClick()
	             	elseif unlocked and edge == "off" then
                		unRightClick()
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

-- Keyboard

	if lockMode == "keyboard" then

-- Select
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


-- Dot/Dash
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

-- Change case

		if pose == "fingersSpread" then
			if edge == "on" then
				caseChange()
			end
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

