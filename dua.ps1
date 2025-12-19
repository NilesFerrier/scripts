#NAIK Software Install Script
#DUA
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



#Install DUA
#Check for Existance of C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent
$directoryPath = "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent"

if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    invoke-webrequest -uri "https://www.googleapis.com/drive/v3/files/1laGm_jkABQ1mhaYm_aIrd2RH2jRnYkNI?alt=media&key=AIzaSyAO_Tkb7Enr2LKImq0xrZFQugLff_rm3lI" -outfile c:\temp\dua.zip
    expand-archive -Path C:\temp\dua.zip -DestinationPath C:\temp\
    msiexec /I "C:\temp\DUA\ODM_DesktopUpdateAgent.msi" TRANSFORMS="c:\temp\DUA\Naik_DUA.mst" /qn
    #Copy stop-applications
    xcopy c:\temp\DUA\stop-applications.ps1 C:\ProgramData\Quest\DUA\Script\PreScript\
    Write-Host "Directory DUA Installed successfully."
} else {
    Write-Host "Directory DUA already exists."
}