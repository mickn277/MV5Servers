#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#  MW CUSTOM: Customisatons to make Oracle XE 18c work better.
#
# Requirements:
#  VM must have 3GB memory, otherwise oracle XE 18c may fail to start.
#
# History:
#  05/07/2019 - Mick Wells, Wrote Script
# --------------------------------------------------------------------------------

echo 'DATABASE-CONFIG Start'

echo 'DATABASE-CONFIG Apply Tuning'
# set environment variables
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
export ORACLE_SID=XE
export PATH=$PATH:$ORACLE_HOME/bin

# Increase memory size to max, requres VM to have 3GB ram:
su -l oracle -c 'sqlplus / as sysdba <<EOF
-- Rollback Prep:
create pfile from spfile;
-- Set the dynamic parameters. Assuming Oracle has full control.
ALTER SYSTEM SET PGA_AGGREGATE_TARGET=0 SCOPE=SPFILE;
ALTER SYSTEM SET SGA_MAX_SIZE=0 SCOPE=SPFILE;
ALTER SYSTEM SET SGA_TARGET=0 SCOPE=SPFILE;
ALTER SYSTEM SET MEMORY_MAX_TARGET=2G SCOPE=SPFILE;
--Optional make Oracle XE use full 2G memory all the time
--ALTER SYSTEM SET MEMORY_TARGET=2G SCOPE=SPFILE;
shutdown immediate
startup
EOF'

echo 'DATABASE-CONFIG Cron enable offline weekly db backup script'

# Oracle rman backup config:
su -l oracle -c '$ORACLE_HOME/bin/rman target / nocatalog log /vagrant/rman-config.log cmdfile /vagrant/provision-scripts/oracle-rman-config.rman'

# Oracle rman backup schedule:
su -l oracle -c 'mkdir $HOME/bin'
su -l oracle -c 'cp /vagrant/provision-scripts/backup-OraXE18c-full-offline.sh $HOME/bin/'
su -l oracle -c 'chmod +x $HOME/bin/backup-OraXE18c-full-offline.sh'
su -l oracle -c 'crontab /vagrant/provision-scripts/oracle.crontab'
su -l oracle -c 'crontab -l'

echo 'DATABASE-CONFIG Complete'