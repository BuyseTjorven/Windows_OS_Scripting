#variables
$dcIPAddress = "192.168.1.10"
$dc2IPAddress = "192.168.1.11"
$preferredDNSServer = $dcIPAddress
$alternateDNSServer = $dc2IPAddress

# Check and set local DNS servers
$nic = Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and $_.Name -eq "Ethernet0"} | Select-Object -First 1
$dnsServers = Get-DnsClientServerAddress -InterfaceIndex $nic.ifIndex | Select-Object -ExpandProperty ServerAddresses
if ($dnsServers[0] -ne $preferredDNSServer -or $dnsServers[1] -ne $alternateDNSServer) {
    $dnsServers = @($preferredDNSServer, $alternateDNSServer)
    Set-DnsClientServerAddress -InterfaceIndex $nic.ifIndex -ServerAddresses $dnsServers
    Write-Host "Local DNS servers updated."
} else {
    Write-Host "Local DNS servers already set correctly."
}

Add-DnsServerPrimaryZone -NetworkId "192.168.1.0/24" -ReplicationScope Domain
Add-DnsServerResourceRecordPtr -Name "10" -ZoneName "1.168.192.in-addr.arpa" -AllowUpdateAny -TimeToLive 01:00:00 -AgeRecord -PtrDomainName "DC1.ad.contoso.com"
