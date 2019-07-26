#!/bin/bash

echo 'INSTALLS: OS Installs start'

# get up to date
yum update -y
echo 'INSTALLS: yum updated'

# Add postgres yum repository for centos/redhad 7
rpm -Uvh https://yum.postgresql.org/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm
echo 'INSTALLS: postgres yum repository added'

# fix locale warning
#yum reinstall -y glibc-common
#echo LANG=en_US.utf-8 >> /etc/environment
#echo LC_ALL=en_US.utf-8 >> /etc/environment
#echo 'INSTALLER: Locale set'

echo 'INSTALLS: OS Installs complete'