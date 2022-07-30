# --------------------------------------------------------------------------------
# This is just the workings for how to ssh to any vagrant server using ssh on windows.
# This file needs to be placed in the Vagrantfile directory of the server to work.
# --------------------------------------------------------------------------------

# Start in the Vagrant directory, with Vagrantfile ...
if (-Not (Test-Path -Path ".\.vagrant")) {
    Write-Error "Must be run from vagrant directory (with Vagrantfile), exiting script"
    Exit 1
}

#Capture Vagrant server ssh port
$SSHPort=(vagrant port | Select-String -Raw -Pattern "22\s+\(guest\)" | % {$_ -replace '\s+',',' } | % {$_.Split(",")[4] })

$PrivateKeyPath=(Get-ChildItem -Filter "private_key" -Recurse).FullName

#Write-Host "ssh -i $PrivateKeyPath -p $SSHPort vagrant@127.0.0.1"

# SSH using vagrant private key and the vagrant port
ssh -i $PrivateKeyPath -p $SSHPort vagrant@127.0.0.1