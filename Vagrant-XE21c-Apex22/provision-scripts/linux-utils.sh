
#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# Purpose:
#   Install helpful server and process networking and resource utilities to make managing environment easier.
# History:
#   07/02/2019 Mick277@yandex.com, Wrote Script.
# --------------------------------------------------------------------------------

#set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

echo 'INSTALL UTILS: Start'

echo 'INSTALL UTILS: update to latest'
yum -y update

echo 'INSTALL UTILS: install epel repo'
yum install -y epel-release

echo 'INSTALL UTILS: perf and diag utils'
yum install -y glances iftop net-tools

echo 'INSTALL UTILS: Complete'