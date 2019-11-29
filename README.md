# Marvin V5

### Overview

This is a cluster of vagrant virtualbox servers that will provision individually.  They are for learning, are a work in progress and probably will never be finished.

### Learnings
* Vagrant ssh ports that don't conflict
* Vagrantfile dependancy checking
* Provisioning and provisioned checks
* Proxy config's copied from host
* Private network interconnect between hosts
* Common perf and diag utils on all hosts

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

### Network Config
```text
virtualbox intnet is the default internal network name

Vagrant-DevOps-Desktop     - 192.168.0.8  : 22 -> 2221, 
Vagrant-XE18c-Apex19c      - 192.168.0.2  : 22 -> 2222, 1521, 5500, 8080
Vagrant-Docker-Host        - 192.168.0.3  : 22 -> 2223, 8080 -> 8081
Vagrant-OpenSense-Firewall - 192.168.0.1  : 22 -> 2224, 443 -> 10443
Vagrant-Postgres-Timescale - 192.168.0.5  : 22 -> 2225, 5432
Vagrant-Nginx              - 192.168.0.2  : 22 -> 2226, 8080 -> 8082

```

#### Dec 2019 Updates
* Vagrant-Nginx

#### Aug 2019 Updates
* Vagrant-OracleApex19c-XE18c - Working, with backup, private & public networks etc.
* Vagrant-Docker-Host - Docker tests ok, private & public networks etc.
* Vagrant-Postgres - TODO: Postgres built ok, not configured or tested.
* Vagrant-OpenSense-Firewall - Builds.
    * Occasional startup errors, unknown cause.
    * Command: ["modifyvm", "85124747-6da8-4397-8d27-5d3a3070842f", "--natpf1", "ssh,tcp,,2224,,22"]
    * Stderr: VBoxManage.exe: error: A NAT rule of this name already exists

### TODO and Issues

opnsense 
- 10.2.0.1 - lan nic1 intnet
- 10.0.3.15 - Wan nic2

dockerhost & other hosts
10.0.2.15 - nat network
192.168.0.3 - intnet static ip - connects to all other hosts with static intnet

assigning 10.2.0.3 to the intnet of a guest for example, makes the guest unreachable.
