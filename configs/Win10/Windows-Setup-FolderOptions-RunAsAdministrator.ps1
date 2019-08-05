#PowerShell
$key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
#Set-ItemProperty $key ShowSuperHidden 0

$key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer'
Set-ItemProperty $key ShowRecent 0
Set-ItemProperty $key ShowFrequent 0

#Restart explorer is required to make the value changes stick.
Stop-Process -processname explorer
