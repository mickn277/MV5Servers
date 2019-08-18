#!/usr/bin/env bash

# Install Docker on CentOS 7 per
# https://docs.docker.com/engine/installation/linux/docker-ce/centos/
# Post-installation steps for Linux, per
# https://docs.docker.com/engine/installation/linux/linux-postinstall/

set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

echo 'INSTALL DOCKER Start'

echo 'INSTALL DOCKER - Prerequisites'

echo 'INSTALL DOCKER 1. Uninstall old packages, if they exist'
yum remove docker docker-client docker-client-latest docker-common \
    docker-latest docker-latest-logrotate docker-logrotate docker-engine

echo 'INSTALL DOCKER 2. Install required prerequisites'

# lvm2 is probably already installed
yum install --assumeyes yum-utils device-mapper-persistent-data lvm2

echo 'INSTALL DOCKER 3. Install stable repository.'

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# BugFix: --disable repo prints whole repo config, we only want to see enabled
yum-config-manager --disable docker-ce-edge | grep '\[docker\|enabled'
yum-config-manager --disable docker-ce-test | grep '\[docker\|enabled'

echo 'INSTALL DOCKER - Docker Engine - Community'

echo 'INSTALL DOCKER 1. Install the latest version of Docker CE'

yum install --assumeyes docker-ce docker-ce-cli containerd.io

echo 'INSTALL DOCKER 2. Start Docker. Report if it failed.'

systemctl start docker || sudo systemctl status docker.service

echo 'INSTALL DOCKER 3. Verify by running the hello-world image.'

docker run --rm hello-world

echo 'INSTALL DOCKER 4. Config docker to start on boot'
systemctl enable docker

echo 'INSTALL DOCKER 5. Add users to docker group'
usermod -a -G docker vagrant

echo 'INSTALL DOCKER 6. BugFix: Prevent "No such file or directory" on /etc/systemd/system/docker.service.d/http-proxy.conf'
mkdir /etc/systemd/system/docker.service.d
chmod 755 /etc/systemd/system/docker.service.d
cat << EOF >> /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="NO_PROXY=127.0.0.1, 192.168.0.*"
EOF
chmod 0644 /etc/systemd/system/docker.service.d/http-proxy.conf

echo 'INSTALL DOCKER Complete'