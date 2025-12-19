#NAIK Software Install Script
#Crowdstrike
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

#Install Crowdstrike
#https://drive.google.com/file/d/1Xqx27794xPlgPWzomuX9ufjuonnq6rIT/view?usp=sharing
$directoryPath = "C:\Program Files\CrowdStrike"

if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    Write-Host "Directory Crowdstrike does not exist. Creating it now..."
    invoke-webrequest -uri "https://www.googleapis.com/drive/v3/files/1Xqx27794xPlgPWzomuX9ufjuonnq6rIT?alt=media&key=AIzaSyAO_Tkb7Enr2LKImq0xrZFQugLff_rm3lI" -outfile c:\temp\crowdstrike.zip
    expand-archive -Path C:\temp\Crowdstrike.zip -DestinationPath C:\temp\
    $CID = '49A97FF66DCB4F4FB8F794AB548BA466-EC'
    $SensorShare = 'c:\temp\crowdstrike\FalconSensor_Windows.exe'

    if (!(Get-Service -Name 'CSFalconService' -ErrorAction SilentlyContinue)) {
        # The sensor is copied to the following directory
        $SensorLocal = 'C:\Temp\WindowsSensor.exe'
        # Now copy the sensor installer if the share is available
        if (Test-Path -Path $SensorShare) {
            Copy-Item -Path $SensorShare -Destination $SensorLocal -Force
        }
        # Now check to see if the service is already present and if so, don't bother running installer.
        & $SensorLocal /install /quiet /norestart CID=$CID
}
    Write-Host "Directory Crowdstrike Installed."
} else {
    Write-Host "Crowdstrike already exists."
}