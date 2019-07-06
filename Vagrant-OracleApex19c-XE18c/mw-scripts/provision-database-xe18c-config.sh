#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#  
# Requirements:
#  
# History:
#  05/07/2019 - Mick Wells, Wrote Script
# --------------------------------------------------------------------------------

# set environment variables
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
export ORACLE_SID=XE
export PATH=$PATH:$ORACLE_HOME/bin

# enable global port for EM Express
su -l oracle -c 'sqlplus / as sysdba <<EOF
-- Rollback Prep:
create pfile from spfile;
-- Set the dynamic parameters. Assuming Oracle has full control.
ALTER SYSTEM SET PGA_AGGREGATE_TARGET=0 SCOPE=SPFILE;
ALTER SYSTEM SET SGA_MAX_SIZE=0 SCOPE=SPFILE;
ALTER SYSTEM SET SGA_TARGET=0 SCOPE=SPFILE;
ALTER SYSTEM SET MEMORY_MAX_TARGET=2G SCOPE=SPFILE;
shutdown immediate
startup
EOF'

#MW: Use rlwrap for sqlplus
yum install -y rlwrap
echo 'MW CUSTOM: Install rlwrap'

echo '#MW: add rlwrap' >> /home/oracle/.bashrc
echo 'alias sqlplus="rlwrap -i sqlplus"' >> /home/oracle/.bashrc
echo 'MW CUSTOM: add alias sqlplus rlwrap'