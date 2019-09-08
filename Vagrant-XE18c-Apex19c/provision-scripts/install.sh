#!/usr/bin/env bash

echo 'INSTALL: Start'

# get up to date
#yum update -y

# run OL Yum configuration
/usr/bin/ol_yum_configure.sh
echo 'INSTALL: System updated'

# Install Oracle Database prereq and openssl packages
# (preinstall is pulled automatically with 18c XE rpm, but it
#  doesn't create /home/oracle unless it's installed separately)
yum install -y oracle-database-preinstall-18c openssl

echo 'INSTALL: Complete'
