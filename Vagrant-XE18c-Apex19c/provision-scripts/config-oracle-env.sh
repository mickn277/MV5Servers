#!/bin/bash

echo 'CONFIG ENV: Start region settings'

#MW: Use rlwrap for sqlplus
echo 'CONFIG ENV: Install rlwrap'
yum install -y rlwrap

echo 'CONFIG ENV: add alias rlwrap for sqlplus rman'
echo '# add rlwrap' >> /home/oracle/.bashrc
echo 'alias sqlplus="rlwrap -i $ORACLE_HOME/bin/sqlplus"' >> /home/oracle/.bashrc
echo 'alias rman="rlwrap -i $ORACLE_HOME/bin/rman"' >> /home/oracle/.bashrc

echo 'CONFIG ENV: Complete region settings'