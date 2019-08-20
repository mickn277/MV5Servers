#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#   Configure consistant regional settings including 
#   timezone and language across all servers.
# --------------------------------------------------------------------------------

#set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

echo 'CONFIG REGION Start'

echo 'CONFIG REGION Set timezone'
timedatectl set-timezone Australia/Brisbane

echo 'CONFIG REGION Set locale'
yum reinstall -y glibc-common
echo LANG=en_AU.utf-8 >> /etc/environment
echo LC_ALL=en_AU.utf-8 >> /etc/environment

echo 'CONFIG REGION Complete'
