Import-Module ActiveDirectory
Get-ADUser -Filter 'Name -like "roar*"' -SearchBase "$((Get-ADDomain).DistinguishedName)" | Disable-ADAccount
Get-ADUser -Filter 'Name -like "backup*"' -SearchBase "$((Get-ADDomain).DistinguishedName)" | Disable-ADAccount
Get-ADUser -Filter 'Name -like "Lion*"' -SearchBase "$((Get-ADDomain).DistinguishedName)" | Disable-ADAccount
Get-ADUser -Filter 'Name -like "ATO Roar*"' -SearchBase "$((Get-ADDomain).DistinguishedName)" | Disable-ADAccount

Add-ADGroupMember -Identity "Protected Users" -Members "Atlantic"
Add-ADGroupMember -Identity "Protected Users" -Members "abpadmin"
Add-ADGroupMember -Identity "Protected Users" -Members "Administrator"
Add-ADGroupMember -Identity "Protected Users" -Members "atoadmin"
Add-ADGroupMember -Identity "Protected Users" -Members "acptech"

Add-ADGroupMember -Identity "Protected Users" -Members "acpautomate"

Get-ADGroupMember -Identity "Protected Users"

exit 0

