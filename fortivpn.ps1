# Define VPN profile variables
$vpnName = "Wong_FlemingVPN1"
$vpnDescription = "VPN Configuration for Wong Fleming1"
$vpnServer = "mail.wongfleming.com:4434"

# Define the registry path for the VPN tunnel
$registryPath = "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\Wong_FlemingVPN"

# Check if the VPN profile already exists
    if ((Test-Path -LiteralPath $registryPath) -ne $true) {
        Write-Host "Creating FortiClient VPN profile: $($vpnName)"

        # Create the VPN tunnel registry key
        New-Item $registryPath -Force -ErrorAction SilentlyContinue

        # Set VPN tunnel properties
        New-ItemProperty -Path $registryPath -Name 'Description' -Value $vpnDescription -PropertyType String -Force -ErrorAction SilentlyContinue
        New-ItemProperty -Path $registryPath -Name 'Server' -Value $vpnServer -PropertyType String -Force -ErrorAction SilentlyContinue
        New-ItemProperty -Path $registryPath -Name 'promptusername' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue
        New-ItemProperty -Path $registryPath -Name 'promptcertificate' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue
        New-ItemProperty -Path $registryPath -Name 'ServerCert' -Value '1' -PropertyType String -Force -ErrorAction SilentlyContinue
        # Add any other necessary properties identified in step 2
    } else {
        Write-Host "FortiClient VPN profile: $($vpnName) already exists."
    }