#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#  
# Requirements:
#  
# History:
#  07/02/2019 - Mick Wells, Wrote Script.
# --------------------------------------------------------------------------------

export BINDIR=/vagrant/mw-scripts
export ORAENV_ASK="NO"
export ORACLE_SID=XE
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE

LD_LIBRARY_PATH=$ORACLE_HOME/lib; export LD_LIBRARY_PATH
PATH=$PATH:$ORACLE_HOME/bin; export PATH
EMAILTO=mickawells70@gmail.com
BACKUPDIR=/vagrant/backup

export PATH=$PATH:$ORACLE_HOME/bin

LOGFILE="$BACKUPDIR/$ORACLE_SID/rman-backup-$ORACLE_SID-`date '+%Y%m%d-%H%M%S'`.log"
#CMDFILE="$BACKUPDIR/$ORACLE_SID/rman-backup-$ORACLE_SID.rman"

if [ ! -d "$BACKUPDIR" ]; then
  mkdir $BACKUPDIR/$ORACLE_SID
  if [ ! -d $BACKUPDIR/$ORACLE_SID ]; then
    echo backup aborted, backup directory "$BACKUPDIR/$ORACLE_SID" can not be created >> $LOGFILE;
    exit 1
  fi
fi

#Start date and time of the backup
BACKUPSTART=`date '+%d/%m/%Y %H:%M:%S'`
FREESPACE_INITIAL=`df -h $BACKUPDIR|grep '/'|awk '{ print $6 " " $3 " of " $2 " used, use is " $5 }'`
USEDSPACE_INITIAL=`du -h $BACKUPDIR/$ORACLE_SID`

#Perform the offline backup
rman target / nocatalog log $LOGFILE <<EOF
RUN {
shutdown immediate;
startup mount;

allocate channel c1 device type disk format '/vagrant/backups/XE/%U' MAXPIECESIZE 5000 M MAXOPENFILES 16;
allocate channel c2 device type disk format '/vagrant/backups/XE/%U' MAXPIECESIZE 5000 M MAXOPENFILES 16;

backup database tag "Backup_XE_DB";
backup spfile current controlfile tag "Backup_XE_SP_CF";
sql "create pfile=''/vagrant/backups/XE/initXE.ora'' from spfile";

alter database open;

delete noprompt obsolete;

restore database validate;
quit;
}
EOF

#End date an time of the backup
echo "--------------------------------------------------------------------------------" >> $LOGFILE
echo "Start:$BACKUPSTART - End:`date '+%d/%m/%Y %H:%M:%S'`" >> $LOGFILE
echo "--------------------------------------------------------------------------------" >> $LOGFILE

#Freespace:
echo "--------------------------------------------------------------------------------" >> $LOGFILE
echo $FREESPACE_INITIAL >> $LOGFILE
echo `df -h $BACKUPPATH|grep '/'|awk '{ print $6 " " $3 " of " $2 " used, use is " $5 }'` >> $LOGFILE
echo "--------------------------------------------------------------------------------" >> $LOGFILE

#Usedspace:
echo "--------------------------------------------------------------------------------" >> $LOGFILE
echo $USEDSPACE_INITIAL >> $LOGFILE
echo `du -h $BACKUPPATH/$ORACLE_SID` >> $LOGFILE
echo "--------------------------------------------------------------------------------" >> $LOGFILE

#If an error occured during backup, subject should reflect this
if [ `grep RMAN- $LOGFILE | wc -l` -gt 0 ]; then
  SUBJECT="ERROR in backup of ${ORACLE_SID} "
else
  SUBJECT="SUCCESS backing up ${ORACLE_SID} "
fi

#Mail the results of the backup to the group mailbox
if [ `uname` = "Linux" ]; then
  /bin/mail -s "${SUBJECT}" ${EMAILTO} < $LOGFILE
fi

#Cleanup old backup logfiles:
find `dirname ${LOGFILE}` -name '*.log' -ctime +60 -exec rm -f {} \;

exit 0











