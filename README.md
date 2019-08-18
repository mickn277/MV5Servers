# Marvin V5

### Overview

This is a cluster of vagrant virtualbox servers that will provision individually.  They are for learning, are a work in progress and probably will never be finished.

### Requirements
* Windows 10 64bit host OS assumed (Others not tested)
* OS Minimum: 16GB ram, 8 cores.  
* OS Recommended: 32GB ram and 16 cores
* Powershell/Cmd for some scripts
* VirtualBox Installed
    * **NOTE:** Don't install Virtualbox Extension Pack on corporate machines unless it's licenced.
* Vagrant Installed

### Virtualbox Setup
```text
(Optional) File -> Preferences 
 -> General - Default Machine Folder: C:\var\VirtualBox VMs
 -> Display : Scaling(150% for 4K monitor)
 -> Extensions : Only for home users or with Oracle License
```

### Vagrant Setup
```powershell
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-reload
```

### Learnings
* They demonstrate how to set Vagrant ssh ports and names so they don't conflict
* Vagrantfile's have more features than many, like ...
    * Dependancy checking
    * Provisioning and and provisioned checks
    * Proxy config's copied from host.

### TODO: 
Private network on all hosts shows ip6 only.  Need ip4 to map between hosts.