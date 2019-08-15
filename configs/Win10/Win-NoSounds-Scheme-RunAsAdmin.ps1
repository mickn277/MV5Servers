#https://superuser.com/questions/1300539/change-sound-scheme-in-windows-via-register/1397681

# The selected scheme is at HKEY_CURRENT_USER\AppEvents\Schemes, which defaults to .Default. So set the selected scheme by changing this to .None:
New-ItemProperty -Path HKCU:\AppEvents\Schemes -Name "(Default)" -Value ".None" -Force | Out-Null

# Event sounds will still play, so the selected scheme must be applied.

# Since you're applying a "no sounds" theme, just clear out all the values. This can be accomplished by an one-liner:
#Get-ChildItem -Path "HKCU:\AppEvents\Schemes\Apps" | Get-ChildItem | Get-ChildItem | Where-Object {$_.PSChildName -eq ".Current"} | Set-ItemProperty -Name "(Default)" -Value ""