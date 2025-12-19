#NAIK Software Install Script
#ThreatLocker
#Jeff Surofsky, Atlantic Tomorrows Office
#jsurofsky@tomorrowsoffice.com


#set protocol to tls version 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Check for Existance of C:\temp
$directoryPath = "C:\temp"

if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    Write-Host "Directory '$directoryPath' does not exist. Creating it now..."
    New-Item -Path $directoryPath -ItemType Directory | Out-Null
    Write-Host "Directory '$directoryPath' created successfully."
} else {
    Write-Host "Directory '$directoryPath' already exists."
}

#Install ThreatLocker
#Check for Existance of C:\Program Files\ThreatLocker
$directoryPath = "C:\Program Files\ThreatLocker"
#https://drive.google.com/file/d/1vA5799pMfIua7SGO-_jhS2y1VeM2Upjw/view?usp=sharing

if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    invoke-webrequest -uri "https://www.googleapis.com/drive/v3/files/1vA5799pMfIua7SGO-_jhS2y1VeM2Upjw?alt=media&key=AIzaSyAO_Tkb7Enr2LKImq0xrZFQugLff_rm3lI" -outfile c:\temp\threatlocker.zip
    expand-archive -Path C:\temp\threatlocker.zip -DestinationPath C:\temp\
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"C:\temp\Threatlocker\Threatlocker_670f48e2a26be4b0aefda209.msi`" /qn /norestart" -Wait -NoNewWindow
    Write-Host "Directory ThreatLocker installed successfully."
} else {
    Write-Host "Directory ThreatLocker already exists."
}