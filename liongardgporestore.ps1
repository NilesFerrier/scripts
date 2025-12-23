powershell.exe -ExecutionPolicy Bypass -File 


# Import the Group Policy module if not already loaded
Import-Module GroupPolicy

# Define the GPO name
$GPO_Name = "Liongard Run as System"

# Create a new, blank GPO
New-GPO -Name $GPO_Name -Comment "Configures Liongard Roar to run as System"

New-GPLink -Name "Liongard Run as System" -Target "$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes

invoke-webrequest -uri "https://github.com/NilesFerrier/scripts/raw/refs/heads/main/liongard.zip" -outfile c:\temp\liongard.zip
expand-archive -Path C:\temp\liongard.zip -DestinationPath C:\temp\

New-GPO -Name "Liongard Run as System"
Import-GPO -BackupGpoName "Liongard Run as System" -TargetName "Liongard Run as System" -Path "c:\temp\liongard"






