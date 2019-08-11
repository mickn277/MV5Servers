# Linux Commands

### OS Commands
```bash
# Linux Release:
cat /etc/*-release | grep release | head -1



```

## Install and patch

### Example Install from custom repo
```bash
# Install repo
sudo yum-config-manager --quiet --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Enable / disable repo
sudo yum-config-manager --enable docker-ce-test

# Install from repo
sudo yum install --assumeyes --quiet docker-ce

# Start installed service
sudo systemctl start docker

# Enable installed service
sudo systemctl enable docker
```

## Crontab Template
```shell
#!/bin/sh

# +--------- Minute            (0 - 59)
# | +------- Hour              (0 - 23)
# | | +----- Day of the Month  (1 - 31)
# | | | +--- Month of the Year (1 - 12 or jan,feb...)
# | | | | +- Day of the Week   (1 - 7, Monday = 1 or mon,tue...)
# * * * * *  CommandToBeExecuted
#Examples:
0 2 * * * /bin/sh backup.sh # Execute at 2am daily.
0 5,17 * * * /scripts/script.sh # Execute 5am 5pm daily
0 17 * * sat,sun  /scripts/script.sh # Execute on Sat & Sun at 5pm
[@yearly|@monthly|@weekly|@daily|@hourly|@reboot] # Execute command in the first min after new time period
```
## Crontab Commands
```shell
# Edit a crontab
crontab -e

# Edit a users crontab as root
crontab -u username -e

# List crontab contents
crontab -l

# Replace crontab from file
crontab [file]

# Pipe file into new contab
cat mynotepadfile | crontab -
```
