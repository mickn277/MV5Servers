#!/bin/sh

# --------------------------------------------------------------------------------
# Purpose:
#  This script will backup one Oracle database, mounting the remote server
#   first
# Requirements:
#  chown oracle:oinstall rman-ORACLE_SID-OraBack.sh
#  chmod 744 rman-ORACLE_SID-OraBack.sh
#  All required environment vars are set in this script as none are available when
#   cron runs the script.
# History:
#  05/07/2007 - Mick Wells, Modified to work on solaris, all but mount_nfs.sh tested OK.
#  07/02/2007 - Mick Wells, Script Author.
# --------------------------------------------------------------------------------

BINDIR=/u01/oracle/scripts; export BINDIR
ORAENV_ASK="NO"; export ORAENV_ASK
ORACLE_SID=<ORACLE_SID>; export ORACLE_SID
ORACLE_HOME=/ora/product/10.2.0/db; export ORACLE_HOME
LD_LIBRARY_PATH=$ORACLE_HOME/lib; export LD_LIBRARY_PATH
PATH=$PATH:$ORACLE_HOME/bin; export PATH
EMAILTO=<GROUP-EMAIL>
BACKUPPATH=/mnt/OraBack

LOGFILE="$BINDIR/rman-$ORACLE_SID-logs/rman-$ORACLE_SID-OraBack-`date '+%Y%m%d-%H%M%S'`.log"
CMDFILE="$BINDIR/rman-$ORACLE_SID-oraback.rman"

$BINDIR/mount_nfs.sh mount
if [ $? -ne 0 ]
then
  echo backup aborted, mount "$BACKUPPATH" failed >> $LOGFILE;
else
	#Start date and time of the backup
	BACKUPSTART=`date '+%d/%m/%Y %H:%M:%S'`
	FREESPACE_INITIAL=`df -h $BACKUPPATH|grep '/'|awk '{ print $6 " " $3 " of " $2 " used, use is " $5 }'`
	USEDSPACE_INITIAL=`du -h $BACKUPPATH/$ORACLE_SID`

	#Perform the rman backup
	#$ORACLE_HOME/bin/rman target / catalog rman/rman@rman cmdfile $CMDFILE log $LOGFILE
	$ORACLE_HOME/bin/rman target / nocatalog cmdfile $CMDFILE log $LOGFILE

	#End date an time of the backup
	echo "--------------------------------------------------------------------------------" >> $LOGFILE
	echo "Start:$BACKUPSTART - End:`date '+%d/%m/%Y %H:%M:%S'`" >> $LOGFILE
	echo "--------------------------------------------------------------------------------" >> $LOGFILE

	#Freespace after backup
	echo "--------------------------------------------------------------------------------" >> $LOGFILE
	echo $FREESPACE_INITIAL >> $LOGFILE
	echo `df -h $BACKUPPATH|grep '/'|awk '{ print $6 " " $3 " of " $2 " used, use is " $5 }'` >> $LOGFILE
	echo "--------------------------------------------------------------------------------" >> $LOGFILE

	#Usedspace after backup
	echo "--------------------------------------------------------------------------------" >> $LOGFILE
	echo $USEDSPACE_INITIAL >> $LOGFILE
	echo `du -h $BACKUPPATH/$ORACLE_SID` >> $LOGFILE
	echo "--------------------------------------------------------------------------------" >> $LOGFILE

	$BINDIR/mount_nfs.sh umount
fi

#If an error occured during backup, subject should reflect this
if [ `grep RMAN- $LOGFILE | wc -l` -gt 0 ]
then
  SUBJECT="BACKUP ERROR for ${ORACLE_SID} "
else
  SUBJECT="Backup successfull for ${ORACLE_SID} "
fi

#Mail the results of the backup to the group mailbox
if [ `uname` = "SunOS" ]
then
	/usr/bin/mailx -s "${SUBJECT}" ${EMAILTO} < $LOGFILE
elif [ `uname` = "Linux" ]; then
	/bin/mail -s "${SUBJECT}" ${EMAILTO} < $LOGFILE
fi

#Cleanup old backup logfiles:
find `dirname ${LOGFILE}` -name '*.log' -ctime +60 -exec rm -f {} \;

exit 0