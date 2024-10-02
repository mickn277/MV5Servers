#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#   Install oracle database from downloaded RPM.
# History:
#   07/02/2019 Mick277@yandex.com, Wrote Script, Oracle 18c.
#   20/06/2022 07/02/2019 Mick277@yandex.com, Upgraded for Oracle 21c.
# Docs:
#   ??
# --------------------------------------------------------------------------------


echo 'INSTALL DB: Start'

# remove fake entry to hostname pointing to 127.0.0.1
sed -i -e "/$HOSTNAME/d" /etc/hosts
echo "10.0.2.15 $HOSTNAME" >> /etc/hosts

# Install Oracle Database prereq and openssl packages
# (preinstall is pulled automatically with 21c XE rpm, but it
#  doesn't create /home/oracle unless it's installed separately)
yum install -y oracle-database-preinstall-21c openssl
echo 'INSTALL DB: db installs and updates complete'

# set environment variables
echo "export ORACLE_BASE=/opt/oracle" >> /home/oracle/.bashrc && \
echo "export ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE" >> /home/oracle/.bashrc && \
echo "export ORACLE_SID=XE" >> /home/oracle/.bashrc && \
echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >> /home/oracle/.bashrc
echo 'INSTALL DB: Environment variables set'

timedatectl set-timezone "$SYSTEM_TIMEZONE"
echo 'INSTALL DB: Timezone updated'

echo 'INSTALL DB: Oracle Database Installation Started up'

# Install Oracle
INSTALL_DOWNLOAD_PATH=`ls /vagrant/downloads/oracle-database-xe*.x86_64.rpm |tail -1`
yum -y localinstall $INSTALL_DOWNLOAD_PATH

echo 'INSTALL DB: Oracle software installed'

# Auto generate ORACLE PWD if not passed on
export ORACLE_PWD=${ORACLE_PWD:-"`openssl rand -base64 8`1"}

# Create database
mv /etc/sysconfig/oracle-xe-21c.conf /etc/sysconfig/oracle-xe-21c.conf.original && \
cp /vagrant/provision-scripts/oracle-xe-21c.conf.tmpl /etc/sysconfig/oracle-xe-21c.conf && \
chmod g+w /etc/sysconfig/oracle-xe-21c.conf && \
sed -i -e "s|###ORACLE_CHARACTERSET###|$ORACLE_CHARACTERSET|g" /etc/sysconfig/oracle-xe-21c.conf && \
sed -i -e "s|###ORACLE_PWD###|$ORACLE_PWD|g" /etc/sysconfig/oracle-xe-21c.conf

# required for database creation
. /home/oracle/.bashrc
su - oracle -c "mkdir -p $ORACLE_BASE/admin"

# start listener and datbase configuration
/etc/init.d/oracle-xe-21c configure

echo 'INSTALL DB: Database created'

# add tns entry for XEPDB1
chmod o+r /opt/oracle/product/21c/dbhomeXE/network/admin/tnsnames.ora

# add tnsnames.ora entry for PDB
echo 'XEPDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oracle-21c-apex)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XEPDB1)
    )
  )
' >> /opt/oracle/product/21c/dbhomeXE/network/admin/tnsnames.ora

echo 'INSTALL DB: TNS entry added'

#clean up temporary entry in /etc/hosts
sed -i -e "s/10.0.2.15/127.0.0.1/" /etc/hosts

# configure systemd to start oracle instance on startup
systemctl daemon-reload
systemctl enable oracle-xe-21c
systemctl restart oracle-xe-21c
echo "INSTALL DB: Created and enabled oracle-xe-21c systemd's service"

# enable global port for EM Express
su -l oracle -c 'sqlplus / as sysdba <<EOF
   EXEC DBMS_XDB_CONFIG.SETGLOBALPORTENABLED (TRUE);
   exit
EOF'

echo 'INSTALL DB: Global EM Express port enabled'

echo $ORACLE_PWD > /vagrant/apex-pwd.log

echo "ORACLE PASSWORD FOR SYS, SYSTEM AND PDBADMIN: $ORACLE_PWD";

echo "INSTALL DB: Complete, database ready to use!";
