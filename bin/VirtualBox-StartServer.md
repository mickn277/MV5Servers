# VirtualBox Start Server Script.

## Requirements

* VirtualBox must be installed with SDK and Python bindings

## Python Installs

```powershell
pip3 install virtualbox
pip3 install pywin32
```
## Run in Powershell as Administrator

```powershell
# Setup the installed VBoxAPI
cd "C:\Program Files\Oracle\VirtualBox\sdk\install"
$VBOX_INSTALL_PATH="C:\Program Files\Oracle\VirtualBox"
python vboxapisetup.py install
```