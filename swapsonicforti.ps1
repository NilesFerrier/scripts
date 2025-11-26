#Remove Sonicwall Netextender
#Download FortiClient MSI
#Install FortiClient MSI

#Find Sonicwall NetExtender
Get-WmiObject Win32_Product | Where-Object {$_.Name -Like "Sonicwall Net*"}

#Remove Sonicwall Extender
Get-WmiObject Win32_Product | Where-Object {$_.Name -Like "Sonicwall Net*"} | ForEach-Object { $_.Uninstall() }

#Install Forticlient
invoke-webrequest -uri "https://drive.google.com/uc?export=download&id=1EZ0oe9uiujrnv_e4K2-ITo_euHJmweqZ" -outfile c:\temp\forticlient.msi
msiexec /I "C:\temp\forticlient.msi" /qn