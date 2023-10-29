Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.Run "SystemSettings.exe"

For x = 1 To 4
    WScript.Sleep 100
    WshShell.SendKeys "{TAB}"
Next
For x = 1 To 2
    WScript.Sleep 100
    WshShell.SendKeys "{RIGHT} {DOWN}"
Next
WScript.Sleep 100
WshShell.SendKeys "{ENTER}"
WScript.Sleep 100
WshShell.SendKeys "{TAB}"
For x = 1 To 2 
    WScript.Sleep 100
    WshShell.SendKeys "{DOWN}"
Next
WScript.Sleep 100
WshShell.SendKeys "{ENTER} {TAB} {ENTER}"
For x = 1 To 4
    WScript.Sleep 100
    WshShell.SendKeys "{TAB}"
Next
WshShell.SendKeys "{ENTER}"
