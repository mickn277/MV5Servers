#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#   Performance tuning after tests for my use cases to make Oracle XE 21c maximise resource use.
# Requirements:
#   VM must have >=3GB memory, otherwise Oracle may fail to start with these changes.
# History:
#   05/07/2019 Mick277@yandex.com, Wrote Script.
# --------------------------------------------------------------------------------

echo 'DATABASE-CONFIG Start'

echo 'DATABASE-CONFIG Apply Tuning'
# set environment variables
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE
export ORACLE_SID=XE
export PATH=$PATH:$ORACLE_HOME/bin

# Increase memory size to max, requres VM to have 3GB ram:
su -l oracle -c 'sqlplus / as sysdba <<EOF
-- Rollback Prep:
create pfile from spfile;
-- Optional make Oracle XE use full 2G memory all the time
-- BugFix: WORKAREA_SIZE_POLICY required SGA_TARGET to be set statically. Why?
ALTER SYSTEM SET PGA_AGGREGATE_TARGET=384M SCOPE=SPFILE;
ALTER SYSTEM SET SGA_MAX_SIZE=1664M SCOPE=SPFILE;
ALTER SYSTEM SET SGA_TARGET=1664M SCOPE=SPFILE;
-- BugFix: Errors during install:
ALTER SYSTEM SET WORKAREA_SIZE_POLICY=AUTO SCOPE=SPFILE;
shutdown immediate
startup
EOF'

# Previously had set this to get maximum dynamic memory management
# bug WORKAREA_SIZE_POLICY=AUTO won't allow it.
# --ALTER SYSTEM SET MEMORY_TARGET=2G SCOPE=SPFILE;
# ALTER SYSTEM SET PGA_AGGREGATE_TARGET=0 SCOPE=SPFILE;
# ALTER SYSTEM SET SGA_MAX_SIZE=0 SCOPE=SPFILE;
# ALTER SYSTEM SET SGA_TARGET=0 SCOPE=SPFILE;

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