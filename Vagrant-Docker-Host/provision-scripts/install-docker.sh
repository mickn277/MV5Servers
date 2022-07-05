#!/usr/bin/env bash

# Docs:
# Install Docker on CentOS 7
# https://docs.docker.com/engine/installation/linux/docker-ce/centos/
# Post-installation steps for Linux
# https://docs.docker.com/engine/installation/linux/linux-postinstall/
# Proxy configuration for Docker on CentOS 7
# https://www.sbarjatiya.com/notes_wiki/index.php/HTTP_proxy_configuration_for_Docker_on_CentOS_7

#set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

echo 'INSTALL DOCKER Start'

echo 'INSTALL DOCKER - BugFix: Prevent "No such file or directory" on /etc/systemd/system/docker.service.d/http-proxy.conf'
mkdir /etc/systemd/system/docker.service.d
chmod 755 /etc/systemd/system/docker.service.d
echo '[Service]' >> /etc/systemd/system/docker.service.d/http-proxy.conf
echo 'Environment="HTTP_PROXY=${HTTP_PROXY}" "NO_PROXY=localhost,127.0.0.0/8,10.0.2.0/24,192.168.0.0/16,172.16.0.0/12"' >> /etc/systemd/system/docker.service.d/http-proxy.conf
chmod 0644 /etc/systemd/system/docker.service.d/http-proxy.conf

echo 'INSTALL DOCKER - Uninstall old packages, if they exist'
yum remove docker docker-client docker-client-latest docker-common \
    docker-latest docker-latest-logrotate docker-logrotate docker-engine

echo 'INSTALL DOCKER - Install required prerequisites'
yum install --assumeyes yum-utils device-mapper-persistent-data lvm2
# lvm2 is probably already installed

echo 'INSTALL DOCKER - Install stable repository.'
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# BugFix: --disable repo prints whole repo config, so just grep for enabled
yum-config-manager --disable docker-ce-edge | grep '\[docker\|enabled'
yum-config-manager --disable docker-ce-test | grep '\[docker\|enabled'

echo 'INSTALL DOCKER - Docker Engine - Community'
yum install --assumeyes docker-ce docker-ce-cli containerd.io

echo 'INSTALL DOCKER - Start Docker. Report if it failed.'
systemctl start docker || sudo systemctl status docker.service

echo 'INSTALL DOCKER - Config docker to start on boot'
systemctl enable docker

echo 'INSTALL DOCKER - Add users to docker group'
usermod -a -G docker vagrant

echo 'INSTALL DOCKER - Verify by running the hello-world image.'
docker run --rm hello-world

echo 'INSTALL DOCKER Complete'