#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# Purpose:
#   Install and configure nginx server
# --------------------------------------------------------------------------------

#set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

echo 'INSTALL NGINX Start'

#echo 'INSTALL NGINX - prereq - update to latest'
#yum -y update

#echo 'INSTALL NGINX - prereq - install epel repo'
#yum install -y epel-release

echo 'INSTALL NGINX perf and diag utils'
yum -y install nginx

nginx -v

echo 'INSTALL NGINX Complete'
 