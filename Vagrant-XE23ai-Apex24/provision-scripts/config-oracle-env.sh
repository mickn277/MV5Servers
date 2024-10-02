#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#   rlwrap adds command line history to sqlplus.
# History:
#   05/07/2019 Mick277@yandex.com, Wrote Script.
# --------------------------------------------------------------------------------

echo 'CONFIG ENV: Start region settings'

#Use rlwrap for sqlplus
echo 'CONFIG ENV: Install rlwrap'
yum install -y rlwrap

echo 'CONFIG ENV: add alias rlwrap for sqlplus rman'
echo '# add rlwrap' >> /home/oracle/.bashrc
echo 'alias sqlplus="rlwrap -i $ORACLE_HOME/bin/sqlplus"' >> /home/oracle/.bashrc
echo 'alias rman="rlwrap -i $ORACLE_HOME/bin/rman"' >> /home/oracle/.bashrc

echo 'CONFIG ENV: Complete region settings'
