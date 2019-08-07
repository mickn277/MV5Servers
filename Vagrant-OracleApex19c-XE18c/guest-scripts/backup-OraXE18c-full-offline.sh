#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#  
# Requirements:
#  
# History:
#  07/02/2019 - Mick Wells, Wrote Script.

# @/vagrant/mw-scripts/backup-OraXE18c-full-offline.rman
# --------------------------------------------------------------------------------

#DEBUG:
#set -x

export ORAENV_ASK="NO"
export ORACLE_SID=XE
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=$PATH:$ORACLE_HOME/bin

#BINDIR=/vagrant/mw-scripts
EMAILTO=#EMAILTO#
BACKUPDIR=/vagrant/backups
LOGFILE="$BACKUPDIR/$ORACLE_SID/rman-backup-$ORACLE_SID-`date '+%Y%m%d-%H%M%S'`.log"
#CMDFILE="$BACKUPDIR/$ORACLE_SID/rman-backup-$ORACLE_SID.rman"

if [ ! -d "$BACKUPDIR/$ORACLE_SID" ]; then
  mkdir -p $BACKUPDIR/$ORACLE_SID
  if [ ! -d $BACKUPDIR/$ORACLE_SID ]; then
    echo backup aborted, backup directory "$BACKUPDIR/$ORACLE_SID" can not be created >> $LOGFILE;
    exit 1
  fi
fi

cd "$BACKUPDIR/$ORACLE_SID"

#Start date and time of the backup
BACKUPSTART=`date '+%d/%m/%Y %H:%M:%S'`
FREESPACE_INITIAL=`df -h $BACKUPDIR|grep '/'|awk '{ print $6 " " $3 " of " $2 " used, use is " $5 }'`
USEDSPACE_INITIAL=`du -h $BACKUPDIR/$ORACLE_SID`

#Perform the offline backup
$ORACLE_HOME/bin/rman target / nocatalog log $LOGFILE <<EOF
RUN {
shutdown immediate;
startup mount;

allocate channel c1 device type disk format '/vagrant/backups/XE/%U' MAXPIECESIZE 10000M MAXOPENFILES 16;

backup as compressed backupset database tag "BACKUP_XE_DB";
backup spfile current controlfile tag "BACKUP_XE_SP_CF";
sql "create pfile=''/vagrant/backups/XE/initXE.ora'' from spfile";

backup as compressed backupset archivelog all not backed up 2 times tag "BACKUP_XE_AL";
alter database open;

delete noprompt obsolete;

restore database validate;

list backup summary;
}
quit;
EOF

#End date an time of the backup
echo "--------------------------------------------------------------------------------" >> $LOGFILE
echo "Start:$BACKUPSTART - End:`date '+%d/%m/%Y %H:%M:%S'`" >> $LOGFILE
echo "--------------------------------------------------------------------------------" >> $LOGFILE

#Freespace:
echo "--------------------------------------------------------------------------------" >> $LOGFILE
echo $FREESPACE_INITIAL >> $LOGFILE
echo `df -h $BACKUPDIR|grep '/'|awk '{ print $6 " " $3 " of " $2 " used, use is " $5 }'` >> $LOGFILE
echo "--------------------------------------------------------------------------------" >> $LOGFILE

#Usedspace:
echo "--------------------------------------------------------------------------------" >> $LOGFILE
echo $USEDSPACE_INITIAL >> $LOGFILE
echo `du -h $BACKUPDIR/$ORACLE_SID` >> $LOGFILE
echo "--------------------------------------------------------------------------------" >> $LOGFILE

#If an error occured during backup, subject should reflect this
if [ `grep RMAN- $LOGFILE | wc -l` -gt 0 ]; then
  SUBJECT="ERROR in backup of ${ORACLE_SID} "
else
  SUBJECT="SUCCESS backing up ${ORACLE_SID} "
fi

#TODO: Mail the results of the backup to the group mailbox
#if [ `uname` = "Linux" ]; then
#  /bin/mail -s "${SUBJECT}" ${EMAILTO} < $LOGFILE
#fi

#Cleanup old backup logfiles:
find `dirname ${LOGFILE}` -name '*.log' -ctime +30 -exec rm -f {} \;

exit 0











