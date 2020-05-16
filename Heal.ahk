#Persistent
SetKeyDelay, 500
Active := false
SetTimer, SearchForImage, 500
Gui, Add, Edit, x10 y10 w200 r5 vHelpButtonStateText
Gui, Show, w250 h200, Gui
return

Display(text)
{
	GuiControl,,HelpButtonStateText,%text%
}

FindIcon(iconFileName, ByRef xPos, ByRef yPos, xStart, yStart, xEnd, yEnd, delta)
{
	tries := 1
	while(tries <= 5)
	{
		Display("Trying to find " iconFileName ", try " tries)
		ImageSearch, xPos, yPos, %xStart%, %yStart%, %xEnd%, %yEnd%, *%delta% %A_ScriptDir%\%iconFileName%.png
		if (ErrorLevel = 2)
			MsgBox, "Failed searching for the image"
		else if (ErrorLevel = 1) {
		}
		else if (ErrorLevel = 0) {
			return true
		}
		Sleep, 100
		tries := tries + 1
	}
	return false
}

HelpIfPossible()
{
	if(FindIcon("Help", xPos, yPos, 100, 100, 1000, 1000, 100) = true)
	{
		clickX := xPos + 5
		clickY := yPos + 5
		Click, %clickX%, %clickY%
		Sleep, 400
	}
}

OpenHealIfPossible()
{
	startedSuccessfully := false
	if(FindIcon("Heal", xPos, yPos, 100, 100, 1000, 1000, 130) = true)
	{
		; Remember the icon location since the "request help" will be at the same location
		hospitalIconXPos := xPos
		hospitalIconYPos := yPos
		
		Click, %xPos%, %yPos%
		Display("Heal menu should be open")
		Sleep, 400
		if(FindIcon("QuickSelect", xPos, yPos, 1000, 600, 1600, 800, 60) = true)
		{
			Click, %xPos%, %yPos%
			Display("Clicked Quick Select")
			Sleep, 400
			if(FindIcon("Zero", xPos, yPos, 880, 400, 1000, 800, 60) = true)
			{
				Click, %xPos%, %yPos%
				Display("Entering troop amount")
				Sleep, 400
				; Send troop amount with single letter as for some reason SetKeyDelay seems to be ignored when inputting into MEmu
				SendInput, 1
				Sleep, 300
				SendInput, 5
				Sleep, 300
				SendInput, 5
				Sleep, 300
				SendInput, {Enter}
				Sleep, 300
				if(FindIcon("HealButton", xPos, yPos, 1000, 800, 1600, 1200, 60) = true)
				{
					Click, %xPos%, %yPos%
					Display("Started troop healing")
					startedSuccessfully := true
					Sleep, 400
				}
			}
		}
		
		if(startedSuccessfully)
		{
			; Click and hope it actually asks for help
			Click, %hospitalIconXPos%, %hospitalIconYPos%
			Sleep, 400
		}
	}
}

GuiClose:
	ExitApp
	
SearchForImage:
if (Active)
{
	return
}
Active := true
HelpIfPossible()
OpenHealIfPossible()
ACtive := false
return