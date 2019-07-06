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
#  07/02/2007 - Mick Wells, Script Author.
# --------------------------------------------------------------------------------

BINDIR=/u01/oracle/scripts ; export BINDIR;
ORAENV_ASK="NO" ; export ORAENV_ASK;
ORACLE_SID=CSOM ; export ORACLE_SID;
ORACLE_HOME=/u01/oracle/product/10.2.0/db_1 ; export ORACLE_HOME;
LD_LIBRARY_PATH=$ORACLE_HOME/lib ; export LD_LIBRARY_PATH;
PATH=$PATH:$ORACLE_HOME/bin ; export PATH;

BACKUPPATH=/u02/oracle/oraback ;
LOGFILE="$BINDIR/rman-$ORACLE_SID-log/rman-$ORACLE_SID-OraBack-`date '+%Y%m%d-%H%M%S'`.log";
CMDFILE="$BINDIR/rman-$ORACLE_SID-oraback.rman"

	#Start date and time of the backup
	BACKUPSTART=`date '+%d/%m/%Y %H:%M:%S'`;
	FREESPACE_INITIAL=`df -h $BACKUPPATH`;
	USEDSPACE_INITIAL=`du -h --max-depth=1 $BACKUPPATH/$ORACLE_SID`;

	#Perform the rman backup
	#$ORACLE_HOME/bin/rman target / catalog rman/rman@rman cmdfile $CMDFILE log $LOGFILE
	$ORACLE_HOME/bin/rman target / nocatalog cmdfile $CMDFILE log $LOGFILE

	#End date an time of the backup
	echo "--------------------------------------------------------------------------------" >> $LOGFILE;
	echo "Start:$BACKUPSTART - End:`date '+%d/%m/%Y %H:%M:%S'`" >> $LOGFILE;
	echo "--------------------------------------------------------------------------------" >> $LOGFILE;

	#Freespace after backup
	echo "--------------------------------------------------------------------------------" >> $LOGFILE;
	echo $FREESPACE_INITIAL >> $LOGFILE;
	echo `df -h $BACKUPPATH` >> $LOGFILE;
	echo "--------------------------------------------------------------------------------" >> $LOGFILE;

	#Usedspace after backup
	echo "--------------------------------------------------------------------------------" >> $LOGFILE;
	echo $USEDSPACE_INITIAL >> $LOGFILE;
	echo `du -h --max-depth=1 $BACKUPPATH/$ORACLE_SID` >> $LOGFILE;
	echo "--------------------------------------------------------------------------------" >> $LOGFILE;

if [ `grep RMAN- $LOGFILE | wc -l` -gt 0 ]; then
  #An error occured during backup, subject reflect this
  SUBJECT="ERROR backup of ${ORACLE_SID} ";
else
  SUBJECT="SUCCESS backup of ${ORACLE_SID} ";
fi

#Mail the results of the backup to the group mailbox
/bin/mail -s "$SUBJECT" mick.a.wells@team.telstra.com < $LOGFILE;
exit 0;
