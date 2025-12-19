#NAIK Software Install Script
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

#Check for Crowdstrike
#Install Crowdstrike
#https://drive.google.com/file/d/1Xqx27794xPlgPWzomuX9ufjuonnq6rIT/view?usp=sharing
$directoryPath = "C:\Program Files\CrowdStrike"

if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    Write-Host "Directory Crowdstrike does not exist. Creating it now..."
    invoke-webrequest -uri "https://www.googleapis.com/drive/v3/files/1Xqx27794xPlgPWzomuX9ufjuonnq6rIT?alt=media&key=AIzaSyAO_Tkb7Enr2LKImq0xrZFQugLff_rm3lI" -outfile c:\temp\crowdstrike.zip
    expand-archive -Path C:\temp\Crowdstrike.zip -DestinationPath C:\temp\Crowdstrike\
    $CID = '49A97FF66DCB4F4FB8F794AB548BA466-EC'
    $SensorShare = 'c:\temp\crowdstrike\crowdstrike\FalconSensor_Windows.exe'

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

#Install ThreatLocker
#Check for Existance of C:\Program Files\ThreatLocker
$directoryPath = "C:\Program Files\ThreatLocker"
#https://drive.google.com/file/d/1vA5799pMfIua7SGO-_jhS2y1VeM2Upjw/view?usp=sharing

if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    invoke-webrequest -uri "https://www.googleapis.com/drive/v3/files/1vA5799pMfIua7SGO-_jhS2y1VeM2Upjw?alt=media&key=AIzaSyAO_Tkb7Enr2LKImq0xrZFQugLff_rm3lI" -outfile c:\temp\threatlocker.zip
    expand-archive -Path C:\temp\threatlocker.zip -DestinationPath C:\temp\Threatlocker\
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"c:\temp\Threatlocker\Threatlocker_670f48e2a26be4b0aefda209.msi`" /qn /norestart" -Wait -NoNewWindow
    Write-Host "Directory ThreatLocker installed successfully."
} else {
    Write-Host "Directory ThreatLocker already exists."
}

#Install DUA
#Check for Existance of C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent
$directoryPath = "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent"

if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    invoke-webrequest -uri "https://www.googleapis.com/drive/v3/files/1laGm_jkABQ1mhaYm_aIrd2RH2jRnYkNI?alt=media&key=AIzaSyAO_Tkb7Enr2LKImq0xrZFQugLff_rm3lI" -outfile c:\temp\dua.zip
    expand-archive -Path C:\temp\threatlocker.zip -DestinationPath C:\temp\Threatlocker\
    msiexec /I "C:\temp\DUA\ODM_DesktopUpdateAgent.msi" TRANSFORMS="c:\temp\DUA\Naik_DUA.mst" /qn
    #Copy stop-applications
    xcopy c:\temp\DUA\stop-applications.ps1 C:\ProgramData\Quest\DUA\Script\PreScript\
    Write-Host "Directory DUA Installed successfully."
} else {
    Write-Host "Directory DUA already exists."
}


#Remove Sentinel1
#Site token eyJ1cmwiOiAiaHR0cHM6Ly91c2VhMS0wMDguc2VudGluZWxvbmUubmV0IiwgInNpdGVfa2V5IjogIjczYTAyYjJhZGRjZTMwNTUifQ==
#Start-Process -FilePath "C:\Program Files\SentinelOne\Sentinel Agent 24.1.5.277\Uninstall.exe" -Argumentlist "/q", "/uninstall /norestart"
#Start-Process -FilePath "C:\Program Files\SentinelOne\Sentinel Agent 25.1.3.334\Uninstall.exe" -Argumentlist "/q", "/uninstall /norestart"
