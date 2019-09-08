#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# Purpose:
#   Install Centos GUI Desktop and default devops user for the deskop.
#   
# --------------------------------------------------------------------------------

#set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

echo 'CENTOS DESKTOP Start'

echo 'CENTOS DESKTOP install GNOME Desktop, Gui Admin Tools'
yum -y groups install "GNOME Desktop" "Graphical Administration Tools"

# Runlevel    Target Units                          Description
# 0           runlevel0.target, poweroff.target     Shut down and power off the system.
# 1           runlevel1.target, rescue.target       Set up a rescue shell.
# 2           runlevel2.target, multi-user.target   Set up a non-graphical multi-user system.
# 3           runlevel3.target, multi-user.target   Set up a non-graphical multi-user system.
# 4           runlevel4.target, multi-user.target   Set up a non-graphical multi-user system.
# 5           runlevel5.target, graphical.target    Set up a graphical multi-user system.
# 6           runlevel6.target, reboot.target       Shut down and reboot the system.

echo 'CENTOS DESKTOP set default to graphical'
sudo systemctl set-default graphical.target

echo 'CENTOS DESKTOP config.vm.provision :reload required after systemctl change'

echo 'CENTOS DESKTOP Install devops user with randomly generated password ...'

groupadd devops
useradd -g devops -G wheel,users --key PASS_MAX_DAYS=-1 devops

echo 'CENTOS DESKTOP Auto generate an initial secure password for the user'
export PASSWD=${PASSWD:-"`openssl rand -base64 8`1"}
echo ${PASSWD}|passwd --stdin devops
echo ${PASSWD} > /vagrant/devops-pwd.log

echo 'CENTOS DESKTOP Complete'