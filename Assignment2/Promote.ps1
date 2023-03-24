Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName ad.contoso.com -DomainNetBIOSName AD -InstallDNS
