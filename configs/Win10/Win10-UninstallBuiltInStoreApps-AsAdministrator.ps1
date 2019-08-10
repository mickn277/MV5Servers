# --------------------------------------------------------------------------------
#Purpose:
# Uninstall all the useless windows store apps, that aren't any good.
# 
#Usage:
#  Read through the list of apps below and add a # comment at the start of the line of any you wish to keep.
#  Start powershell.exe as administrator, by right clicking on a powershell shortcut. 
#  Run this command to allow the script to run: Set-ExecutionPolicy Unrestricted
#  Then run this script.
#
#Rollback Procedure (As Administrator):
# Reinstall all uninstalled store apps:
# Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
# Reinstall uninstalled app:
# Add-AppxPackage *windowsstore*
#
#History
# 14/11/2015 Mick Wells, Wrote script.
# --------------------------------------------------------------------------------

# Provisioned Windows Apps, not all can be uninstalled
# Get-AppxProvisionedPackage -Online | Format-Table DisplayName, PackageName

# System apps must not be uninstalled, and probably can't be?
# Get-AppxPackage * | Sort Name | Format-Table Name, SignatureKind, NonRemovable

# Potiential apps that can be removed:
# Get-AppxPackage * | Where-Object -Property SignatureKind -eq -Value "Store" | Where-Object -Property Name -notlike -Value "Microsoft.NET*" | Where-Object -Property Name -notlike -Value "Microsoft.VCLibs*" | Sort Name | Format-Table Name, SignatureKind, NonRemovable


# Packages to uninstall:

#Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage
Get-AppxPackage *BingWeather | Remove-AppxPackage
Get-AppxPackage *BingNews | Remove-AppxPackage
Get-AppxPackage *BingSports | Remove-AppxPackage
Get-AppxPackage *BingFinance | Remove-AppxPackage
Get-AppxPackage *CandyCrush* | Remove-AppxPackage
Get-AppxPackage *Facebook* | Remove-AppxPackage
Get-AppxPackage *Twitter* | Remove-AppxPackage
Get-AppxPackage *WindowsCalculator* | Remove-AppxPackage
#Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage
#Get-AppxPackage *windowscamera* | Remove-AppxPackage
#Get-AppxPackage *skypeapp* | Remove-AppxPackage
#Get-AppxPackage *getstarted* | Remove-AppxPackage
#Get-AppxPackage *windowsmaps* | Remove-AppxPackage
Get-AppxPackage *windowsphone* | Remove-AppxPackage
#Get-AppxPackage *photos* | Remove-AppxPackage
#Get-AppxPackage *windowsstore* | Remove-AppxPackage
#Get-AppxPackage *soundrecorder* | Remove-AppxPackage
#Get-AppxPackage Microsoft.Print3D | Remove-AppxPackage
#Get-AppxPackage Microsoft*3DViewer | Remove-AppxPackage
#Get-AppxPackage Microsoft*Photos | Remove-AppxPackage
#Get-AppxPackage Microsoft.YourPhone











