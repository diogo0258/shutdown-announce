
#NoEnv
#SingleInstance force
; the aborting part depends on it being singleinstance force.

	if 0 > 0
		cmd = %1%
	if 0 > 1
		timetocmd = %2%

	; any command other than the ones below will abort, considering the singleinstance force above
	if cmd not in shutdown,reboot,logoff
	{
		Progress, B ZH0 ZX20 ZY20 W500 FS30 CWGreen, Shutdown Cancelled
		Sleep 2000
		exitapp
	}
	
	if timetocmd is not integer
		timetocmd := 5
		
	if (timetocmd < 5)
		timetocmd := 5
	
	CreateProgress := True
	Gosub, Announce
	SetTimer, Announce, 1000

	sleep 500  ; give time to release any pressed keys
	
	; from the docs on Input:
	; Wait for the user to press any key.  Keys that produce no visible character -- such as
	; the modifier keys, function keys, and arrow keys -- are listed as end keys so that they
	; will be detected too.
	Input, key, L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
	
	; if no input, will shutdown before next line.
	; from the docs on Reload: 
	; "Any command-line parameters passed to the original script are not passed to the new instance"
	Reload
	
return


Announce:
	if (timetocmd > 0)
	{
		if CreateProgress
		{
			ProgressOpts := "B ZH0 ZX20 ZY20 W500 FS30 CWRed"
			CreateProgress := False
		}
		else
			ProgressOpts := ""
		
		Progress, %ProgressOpts%, Gonna %cmd% in %timetocmd% seconds.`nPress any key to abort.
		timetocmd--
	}
	else 
	{
		Progress, Off
		SetTimer, Announce, Off
		msgbox % "shutdown /" SubStr(cmd, 1, 1) " /t 00"  ; /s for shutdown, /r for reboot, /l for logoff
		ExitApp  ; avoids showing the cancelled splash after asking to shutdown
	}
return
