#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#  
# Requirements:
#  
# History:
#  05/07/2019 - Mick Wells, Wrote Script
# --------------------------------------------------------------------------------

#DEBUG:
set -x

# Oracle Install Setup
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
export ORACLE_SID=XE
export PATH=$PATH:$ORACLE_HOME/bin

#Backup Setup
BACKUPDIR=/vagrant/backups
BINDIR=/vagrant/scripts
LOGFILE="$BACKUPDIR/$ORACLE_SID/rman-backup-$ORACLE_SID-`date '+%Y%m%d-%H%M%S'`.log"
EMAILTO=mickawells70@gmail.com

# Create backup path if it doesn't exist:
if [ ! -d "$BACKUPDIR/$ORACLE_SID" ]; then
	mkdir $BACKUPDIR/$ORACLE_SID
fi

if [ ! -d "$BACKUPDIR/$ORACLE_SID" ]; then
  echo backup aborted, "$BACKUPDIR/$ORACLE_SID" does not exist >> $LOGFILE;
  exit 1
else
	#Start date and time of the backup
	BACKUPSTART=`date '+%d/%m/%Y %H:%M:%S'`
	FREESPACE_INITIAL=`df -h $BACKUPDIR|grep '/'|awk '{ print $6 " " $3 " of " $2 " used, use is " $5 }'`
	USEDSPACE_INITIAL=`du -h $BACKUPDIR/$ORACLE_SID`
fi

#Example rman:
#$ORACLE_HOME/bin/rman target / [catalog rman/rman@rman|nocatalog] [cmdfile $CMDFILE] [log $LOGFILE]

#Perform the rman backup
$ORACLE_HOME/bin/rman target / nocatalog log $LOGFILE <<EOF
shutdown immediate;
startup mount;
backup spfile;

allocate channel c1 device type disk format '/vagrant/backups/XE/%U' MAXOPENFILES 16;
allocate channel c2 device type disk format '/vagrant/backups/XE/%U' MAXOPENFILES 16;

backup database tag "Backup_Nightly_DB";
backup spfile current controlfile tag "Backup_Nightly_SP_CF";

alter database open;
delete noprompt obsolete;
quit;
EOF

#End date an time of the backup
echo "--------------------------------------------------------------------------------" >> $LOGFILE
echo "Start:$BACKUPSTART - End:`date '+%d/%m/%Y %H:%M:%S'`" >> $LOGFILE
echo "--------------------------------------------------------------------------------" >> $LOGFILE
#Freespace:
echo $FREESPACE_INITIAL >> $LOGFILE
echo `df -h $BACKUPDIR|grep '/'|awk '{ print $6 " " $3 " of " $2 " used, use is " $5 }'` >> $LOGFILE
echo "--------------------------------------------------------------------------------" >> $LOGFILE
#Usedspace:
echo $USEDSPACE_INITIAL >> $LOGFILE
echo `du -h $BACKUPDIR/$ORACLE_SID` >> $LOGFILE

#If an error occured during backup, subject should reflect this
if [ `grep RMAN- $LOGFILE | wc -l` -gt 0 ]; then
  SUBJECT="ERROR rman backup for ${ORACLE_SID} "
else
  SUBJECT="SUCCESS rman backup for ${ORACLE_SID} "
fi

#Mail the results of the backup to the group mailbox
/bin/mail -s "${SUBJECT}" ${EMAILTO} < $LOGFILE

#Cleanup old backup log files:
find `dirname ${LOGFILE}` -name '*.log' -ctime +60 -exec rm -f {} \;

exit 0