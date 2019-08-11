# Marvin V5

### Overview

This is a cluster of vagrant virtualbox servers that will provision individually.  They are for learning, are a work in progress and probably will never be finished.

### Requirements
* Windows 10 host OS (Others not tested)
* Powershell for some configs
* VirtualBox
* Vagrant

### Learnings
* They demonstrate how to set Vagrant ssh ports and names so they don't conflict
* Vagrantfile's have more features than many, like ...
    * Dependancy checking
    * Provisioning and and provisioned checks
    * Proxy config's copied from host.
