#!/usr/bin/env bash

echo 'INSTALL: Start'

# get up to date
#yum update -y

# run OL Yum configuration
/usr/bin/ol_yum_configure.sh
echo 'INSTALL: System updated'

echo 'INSTALL: Complete'
