
#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# Purpose:
#   Install server and process networking and resource utilities to make managing 
#   environment easier and consistant.
# --------------------------------------------------------------------------------

#set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

echo 'LINUX UTILS Start'

echo 'LINUX UTILS install epel repo'
yum install -y epel-release

echo 'LINUX UTILS perf and diag utils'
yum install -y glances iftop net-tools

echo 'LINUX UTILS Complete'