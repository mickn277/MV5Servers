# Linux Commands

### OS Commands
```bash
# Linux Release:
cat /etc/*-release | grep release | head -1



```

## Install and patch

### Install from custom repo
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