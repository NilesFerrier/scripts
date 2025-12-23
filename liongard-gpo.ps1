# Import the Group Policy module if not already loaded
Import-Module GroupPolicy

# Define the GPO name
$GPO_Name = "Liongard Run as System"

# Create a new, blank GPO
New-GPO -Name $GPO_Name -Comment "Configures Liongard Roar to run as System"

New-GPLink -Name "Liongard Run as System" -Target "$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes

# Define the service name and desired startup type
$ServiceName = "roaragent.exe" 
$StartupType = "Automatic"     

# Configure the service
try {
    Set-Service -Name $ServiceName -StartupType $StartupType -ErrorAction Stop
    Start-Service -Name $ServiceName -ErrorAction Stop
    Write-Output "$ServiceName configured to $StartupType and started successfully."
} catch {
    Write-Error "Failed to configure or start the service: $_"
}

Get-CimInstance win32_service -Filter "Name='YourServiceName'" | Invoke-CimMethod -Name Change -Arguments @{StartName="LocalSystem"}

$params = @{
    Name      = 'Liongard Run as System'
    Key       = 'HKLM\SOFTWARE\Policies\Mozilla\Firefox\SanitizeOnShutdown'
    ValueName = 'Cookies'
    Value     = 1
    Type      = 'DWORD'
}
Set-GPRegistryValue @params





