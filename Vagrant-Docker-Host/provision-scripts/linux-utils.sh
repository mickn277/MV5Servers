
#!/usr/bin/env bash

echo 'LINUX UTILS Start'

echo 'LINUX UTILS install epel repo'
yum install -y epel-release

echo 'LINUX UTILS perf and diag utils'
yum install -y glances iftop net-tools

echo 'LINUX UTILS End'