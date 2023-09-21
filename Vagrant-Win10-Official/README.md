# Win10 Official

This builds a Windows 10 Virtual Machine with a 90 day expiry.

## Getting Started

********************************************************************************

### Prerequisites

1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)

### Download Requirements

1. Clone this repository `git clone https://github.com/mickn277/MV5Servers`
2. Change into the `Vagrant-Win10-Official` folder
3. Download [Vagrant Box Image](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/) to some local path, e.g. `C:\tmp\05-Vagrant-Boxes`
4. Add box to vagrant from that path: `vagrant box add file:///C:/tmp/05-Vagrant-Boxes/MSEdge%20-%20Win10.box --name Win10-official`
  * --name is requiret to add local boxes

### Build the server with vagrant

1. Run `vagrant up | tee vagrant.log`, this is helpful as the log goes past the 9999 line limit in powershell. The first time you run this it will provision everything and may take a while.
2. VM Initial username = `IEUser`, password = `Passw0rd!`

### Connecting to the VM

* `vagrant rdp` Should work on  Linux or Windows.
* `vagrant powershell` On Windows Host only at the time of testing.

## Known Issues

********************************************************************************

1. Win10 Official may display a message in the Settings app `Connect to the Internet to activate.`
This is due to a bug and does not impact the activation state or functionality of the virtual machine.
2. Win10 Official virtual machine expire after 90 days. 
Take a snapshot after provisioning, which allows roll back later.
3. The OS patches and requries several reboots after provisioning.

## Troubleshooting

********************************************************************************

#### Edit Vagrantfile for debugging

* Comment in `v.gui = true` to see the Windows GUI, use the Username and password to login.
* Add more video memory, system memory and CPU's in the config if needed.
* If provisioning doesn't complete, try `vagrant up --provision` to force provisioning to continue.

#### WinRM can't be enable when windows thinks it's interfaces are public.

```powershell
# Login using the VirtualBox GUI and the username and password.

# Run a powershell session as administrator.

# Get the InterfaceIndex for any public interface
Get-NetConnectionProfile | Where-Object {$_.NetworkCategory -eq "Public"} | Select-Object InterfaceIndex | `
Set-NetConnectionProfile -InterfaceIndex {$_.InterfaceIndex} -NetworkCategory Private

# Re-Enable WinRM / Powershell Remoting
Enable-PSRemoting -Force

# Enable RDP for IEUser
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="remote desktop" new enable=yes
net localgroup "remote desktop users" IEUser /add
```

On HOST -> Note, this didn't work even when `vagrant powershell` was working

```powershell
# Module might not be installed
Install-Module New-Credential

# Create a Credential object
$credObject = New-Credential -UserName "IEUser" -Password (ConvertTo-SecureString "Passw0rd!" -AsPlainText)

# Test connection
Test-WsMan -ComputerName 127.0.0.1 -Port 5829 -Credential $credObject

# Connect
Get-PSSession -ComputerName 127.0.0.1 -Port 5829 -Credential $credObject
```

## TODO

********************************************************************************

### MUST

### SHOULD

https://4sysops.com/archives/provision-windows-server-2016-with-vagrant-and-powershell-dsc/

## COULD




