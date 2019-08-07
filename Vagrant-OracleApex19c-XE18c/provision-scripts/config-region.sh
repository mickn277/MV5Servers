#!/bin/bash

echo 'CONFIG REGION: Start region settings'

# Timezone 
timedatectl set-timezone Australia/Brisbane
echo 'CONFIG REGION: Timezone updated'

# fix locale warning
yum reinstall -y glibc-common
echo LANG=en_AU.utf-8 >> /etc/environment
echo LC_ALL=en_AU.utf-8 >> /etc/environment
echo 'CONFIG REGION: Locale set'

echo 'CONFIG REGION: Complete region settings'
