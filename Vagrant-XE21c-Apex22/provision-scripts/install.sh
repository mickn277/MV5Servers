#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# Purpose:
#   OS Installs for Oracle, Apex and Ords.
# History:
#   20/06/2022 - Mick277@yandex.com, Wrote Script.
# Docs:
#   https://docs.oracle.com/en/database/oracle/oracle-rest-data-services/22.1/ordig/installing-and-configuring-oracle-rest-data-services.html
# --------------------------------------------------------------------------------

#set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

echo 'INSTALL: Start'

# get up to date
yum update -y

# run OL Yum configuration
/usr/bin/ol_yum_configure.sh
echo 'INSTALL: System updated'

systemctl stop sssd
systemctl disable sssd
echo "BugFix: OL8 Disable sssd from starting to prevent 'Failed to get unit file state for sssd-sudo.socket:' error."

# ORDS Requires JDK 17, which wasn't installed in the default path
# Change to Oracle JDK 18+, was JDK 11.
#su -l oracle -c "OLD_JAVA_HOME=`$ORACLE_HOME/oui/bin/getProperty.sh JAVA_HOME`"
#su -l oracle -c "$ORACLE_HOME/oui/bin/setProperty.sh -name OLD_JAVA_HOME -value $OLD_JAVA_HOME"
#su -l oracle -c "$ORACLE_HOME/oui/bin/setProperty.sh -name JAVA_HOME -value '/usr/java/jdk-18.0.1.1'"
JDK_INSTALL=`ls /vagrant/downloads/jdk-17*.rpm |tail -1`
if [ -f "$JDK_INSTALL" ]; then
    # yum -y --installroot= localinstall $JDK_INSTALL 
    yum -y  localinstall $JDK_INSTALL 
fi

echo 'INSTALL: Complete'