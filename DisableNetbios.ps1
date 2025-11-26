$regkey = "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"

Get-ChildItem $regkey | ForEach-Object { Set-ItemProperty -Path "$regkey\$($_.PSChildName)" -Name NetbiosOptions -Value 2 }