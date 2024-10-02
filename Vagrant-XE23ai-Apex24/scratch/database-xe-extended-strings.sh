#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#   Upgrade CDB and PDB's to 32K strings.
# Requirements:
#   Procedure needs more testing, didn't get a full clean run.
# History:
#   30/10/2022 Mick277@yandex.com, Wrote Script.
# --------------------------------------------------------------------------------

echo 'DATABASE-EXTENDED-STRINGS Start'

echo 'DATABASE-EXTENDED-STRINGS Upgrade'
# set environment variables
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE
export ORACLE_SID=XE
export PATH=$PATH:$ORACLE_HOME/bin

# SQLPLUS>
# show pdbs
#     CON_ID CON_NAME                       OPEN MODE  RESTRICTED
# ---------- ------------------------------ ---------- ----------
#          2 PDB$SEED                       MOUNTED
#          3 XEPDB1                         MOUNTED

# NOTE:
# Oracle provides catcon.pl to run a script across CDB and all PDB's.
# Because it prompts for a password, not sure how to use it in this script so have targeted CDB and the two PDB's individually below.
# The example below is not tested or known to work, but it gives the idea of what it shold be.

# Example:
# mkdir /tmp/utl32k_output
# su -l oracle -c '$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -u SYS -d $ORACLE_HOME/rdbms/admin -l /tmp/utl32k_output -b @$ORACLE_HOME/rdbms/admin/utl32k.sql'
# su -l oracle -c '$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -u SYS -d $ORACLE_HOME/rdbms/admin -l /tmp/utl32k_output -b @$ORACLE_HOME/rdbms/admin/utlrp.sql'
 
su -l oracle -c 'sqlplus / as sysdba <<EOF
-- Enable extended VARCHAR2(32767)
ALTER SYSTEM SET MAX_STRING_SIZE=EXTENDED SCOPE=SPFILE;

shutdown immediate
startup upgrade

-- Upgrade CDB:
alter session set container = cdb$root;
-- Upgrade to extended
@$ORACLE_HOME/rdbms/admin/utl32k.sql
-- Recompile all invalid objects
@$ORACLE_HOME/rdbms/admin/utlrp.sql

-- Upgrade SEED PDB
alter session set container = PDB$SEED;
alter pluggable database PDB$SEED open upgrade;
-- Upgrade to extended
@$ORACLE_HOME/rdbms/admin/utl32k.sql
-- Recompile all invalid objects
@$ORACLE_HOME/rdbms/admin/utlrp.sql
alter pluggable database PDB$SEED close;

-- Upgrade XEPDB1 PDB 
alter session set container = XEPDB1;
alter pluggable database XEPDB1 open upgrade;
-- Upgrade to extended
@$ORACLE_HOME/rdbms/admin/utl32k.sql
-- Recompile all invalid objects
@$ORACLE_HOME/rdbms/admin/utlrp.sql
alter pluggable database XEPDB1 close;

-- Restart the database after upgrade
alter session set container = cdb$root;
shutdown immediate
startup
show pdbs
EOF'

echo 'DATABASE-EXTENDED-STRINGS Complete'