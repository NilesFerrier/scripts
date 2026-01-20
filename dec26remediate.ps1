# powershell.exe -ExecutionPolicy Bypass -File 

# STAGE File Downloads

Write-Output "Setting TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

Write-Output "Downloading Liongard GPO"
invoke-webrequest -uri "https://github.com/NilesFerrier/scripts/raw/refs/heads/main/liongard.zip" -outfile c:\temp\liongard.zip
expand-archive -Path C:\temp\liongard.zip -DestinationPath C:\temp\

Write-Output "Downloading Admx files"
Invoke-WebRequest -Uri "https://github.com/NilesFerrier/scripts/raw/refs/heads/main/admx-files.zip" -OutFile c:\temp\admx-files.zip
Invoke-WebRequest -Uri "https://github.com/NilesFerrier/scripts/raw/refs/heads/main/DisableNetbios.ps1" -OutFile c:\temp\disablenetbios.ps1
Expand-Archive -Path c:\temp\admx-files.zip -DestinationPath C:\temp

Write-Output "Downloading DUO Admx files"
Invoke-WebRequest -Uri "https://dl.duosecurity.com/DuoWinLogon_MSIs_Policies_and_Documentation-latest.zip" -OutFile c:\temp\DuoWinLogon_MSIs_Policies_and_Documentation-latest.zip
Expand-Archive -Path c:\temp\DuoWinLogon_MSIs_Policies_and_Documentation-latest.zip -DestinationPath C:\temp

Write-Output "Putting admx files in their place"
xcopy c:\temp\admx-files\*.admx c:\windows\PolicyDefinitions\ /y
xcopy c:\temp\admx-files\*.adml C:\Windows\PolicyDefinitions\en-US /y
xcopy c:\temp\admx-files\*.admx C:\Windows\SYSVOL\sysvol\$(Get-ADForest -Current LocalComputer)\Policies\PolicyDefinitions\ /y
xcopy c:\temp\admx-files\*.adml C:\Windows\SYSVOL\sysvol\$(Get-ADForest -Current LocalComputer)\Policies\PolicyDefinitions\en-US /y
xcopy c:\temp\DuoWindowsLogon.admx c:\windows\PolicyDefinitions\ /y
xcopy c:\temp\DuoWindowsLogon.adml C:\Windows\PolicyDefinitions\en-US /y
xcopy c:\temp\DuoWindowsLogon.admx C:\Windows\SYSVOL\sysvol\$(Get-ADForest -Current LocalComputer)\Policies\PolicyDefinitions\ /y
xcopy c:\temp\DuoWindowsLogon.adml C:\Windows\SYSVOL\sysvol\$(Get-ADForest -Current LocalComputer)\Policies\PolicyDefinitions\en-US /y

# Disable Roar, and add users to Protected Users Group

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


# CREATE GPOs

# LIONGARD
# GPO that makes liongard run as localsystem
# Import the Group Policy module if not already loaded
Import-Module GroupPolicy
$GPO_Name = "Liongard Run as System"
New-GPO -Name $GPO_Name -Comment "Configures Liongard Roar to run as System"
New-GPLink -Name "Liongard Run as System" -Target "$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes
Import-GPO -BackupGpoName "Liongard Run as System" -TargetName "Liongard Run as System" -Path "c:\temp\"

# Security Remediation GPOs

# Create GPOs
Write-Output "Configuring PSGallery Settings..."

Register-PSRepository -Default -Verbose
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Write-Output "Installing PSFramework..."
Install-Module -Name PSFramework
Write-Output "Installing GPPolicies..."
Install-Module -Name GPWmiFilter -RequiredVersion 1.0.5
Import-Module -Name GPWmiFilter

Write-Output "Creating the 4 GPOs..."
New-GPO -Name "Security Remediations" -Comment "Security Remediations"
New-GPO -Name "Security Remediations - Servers" -Comment "Server Security Remediations - Servers"
New-GPO -Name "Security Remediations - Workstations" -Comment "Workstations Security Remediations"
New-GPO -Name "Security Remediations - Browser Cache" -Comment "Server Browser Cache Cleanup"

Write-Output "Creating the 2 WMI Filters..."
New-GPWmiFilter -Name "Servers" -Server $env:COMPUTERNAME -Expression 'select * from Win32_OperatingSystem where ProductType="2" or ProductType="3"' -Description "Servers"
New-GPWmiFilter -Name "Workstations" -Server $env:COMPUTERNAME -Expression 'Select * from Win32_OperatingSystem WHERE producttype = 1' -Description "Workstations"

Write-Output "Apply WMI Filters..."
$wmifilter = Get-GPWmiFilter -Name "Workstations"
Get-GPO -Name "Security Remediations - Workstations" -Server $env:COMPUTERNAME | Set-GPWmiFilterAssignment -Filter "Workstations"

$wmifilter = Get-GPWmiFilter -Name "Servers"
Get-GPO -Name "Security Remediations - Servers" | Set-GPWmiFilterAssignment -Filter "Servers"

$wmifilter = Get-GPWmiFilter -Name "Servers"
Get-GPO -Name "Security Remediations - Browser Cache" | Set-GPWmiFilterAssignment -Filter "Servers"

Write-Output "Linking 3 GPOs..."
#Workstations GPO done manually based on environment
New-GPLink -Name "Security Remediations - Servers" -Target "OU=Domain Controllers,$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes
New-GPLink -Name "Security Remediations - Browser Cache" -Target "OU=Domain Controllers,$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes
New-GPLink -Name "Security Remediations" -Target "$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes

# Set GPO Parameters
Write-Output "Disable wpad"
$params = @{
    Name      = 'Security Remediations'
    Key       = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp'
    ValueName = 'DisableWpad'
    Value     = 1
    Type      = 'DWORD'
}
Set-GPRegistryValue @params

Write-Output "Disable LLMNR"
$params = @{
    Name      = 'Security Remediations'
    Key       = 'HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient'
    ValueName = 'EnableMulticast'
    Value     = 0
    Type      = 'DWORD'
}
Set-GPRegistryValue @params

Write-Output "Clear Edge and IE Browsing Data on Exit"
#Edge Clear BrowsingDataonExit
$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Microsoft\Edge'
    ValueName = 'ClearBrowsingDataOnExit'
    Value     = 1
    Type      = 'DWORD'
}
Set-GPRegistryValue @params

#IE Clear BrowsingDataonExit
$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Microsoft\Edge'
    ValueName = 'InternetExplorerModeClearDataOnExitEnabled'
    Value     = 1
    Type      = 'DWORD'
}
Set-GPRegistryValue @params 

Write-Output "Firefox Browsing Data on Exit"
$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Mozilla\Firefox\SanitizeOnShutdown'
    ValueName = 'Cache'
    Value     = 1
    Type      = 'DWORD'
}
Set-GPRegistryValue @params

$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Mozilla\Firefox\SanitizeOnShutdown'
    ValueName = 'Cookies'
    Value     = 1
    Type      = 'DWORD'
}
Set-GPRegistryValue @params

$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Mozilla\Firefox\SanitizeOnShutdown'
    ValueName = 'History'
    Value     = 1
    Type      = 'DWORD'
}
Set-GPRegistryValue @params

$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Mozilla\Firefox\SanitizeOnShutdown'
    ValueName = 'Sessions'
    Value     = 1
    Type      = 'DWORD'
}
Set-GPRegistryValue @params

Write-Output "Chrome Browsing Data on Exit"
$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList'
    ValueName = '1'
    Value     = 'autofill'
    Type      = 'String'
}
Set-GPRegistryValue @params

$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList'
    ValueName = '2'
    Value     = 'password_signin'
    Type      = 'String'
}
Set-GPRegistryValue @params


$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList'
    ValueName = '3'
    Value     = 'cached_images_and_files'
    Type      = 'String'
}
Set-GPRegistryValue @params

$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList'
    ValueName = '4'
    Value     = 'browsing_history'
    Type      = 'String'
}
Set-GPRegistryValue @params


$params = @{
    Name      = 'Security Remediations - Browser Cache'
    Key       = 'HKLM\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList'
    ValueName = '5'
    Value     = 'cookies_and_other_site_data'
    Type      = 'String'
}
Set-GPRegistryValue @params



