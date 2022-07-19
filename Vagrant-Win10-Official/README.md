# Win10 Official

This builds a Windows 10 Virtual Machine with a 90 day expiry.

## Getting Started

### Prerequisites
1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)

### Download Requirements
1. Clone this repository `git clone https://github.com/n2779510/MV5Servers`
2. Change into the `Vagrant-Win10-Official` folder
3. Download [Vagrant Box Image](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/) to some local path, e.g. `C:\tmp\05-Vagrant-Boxes`
4. Add box to vagrant from that path: `vagrant box add file:///C:/tmp/05-Vagrant-Boxes/MSEdge%20-%20Win10.box --name Win10-official`
  * --name is requiret to add local boxes
5. 

### Build the server with vagrant
1. Run `vagrant up | tee vagrant.log`, this is helpful as the log goes past the 9999 line limit in powershell. The first time you run this it will provision everything and may take a while.
2. VM Initial username = `IEUser`, password = `Passw0rd!`

3. In the first run we will enable winrm and rdp: `communicator=ssh  vagrant up` ??

## Known Issues

1. Win10 Official virtual machine may display a message in the Settings app that reads `Connect to the Internet to activate.` This is due to a bug and does not impact the activation state or functionality of the virtual machine.
2. Win10 Official virtual machine expire after 90 days. We recommend setting a snapshot when you first install the virtual machine which you can roll back to later.