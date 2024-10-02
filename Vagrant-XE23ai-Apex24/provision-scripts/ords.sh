#!/bin/bash

# --------------------------------------------------------------------------------
# Purpose:
#   Install ords from downloaded RPM.
# History:
#   07/02/2019 Mick277@yandex.com, Wrote Script.  ORDS zip.
#   20/06/2022 Mick277@yandex.com, Upgraded for ORDS 22.x from RPM.  Full rewrite.
#   05/07/2022 Mick277@yandex.com, Fixed install bugs.
# Docs:
#   https://docs.oracle.com/en/database/oracle/oracle-rest-data-services/22.1/ordig/installing-and-configuring-oracle-rest-data-services.html
#
# /vagrant/provision-scripts/ords.sh
# --------------------------------------------------------------------------------

#set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

. /home/oracle/.bashrc 

echo "INSTALL ORDS: Start"

#export PATH=/usr/sbin:/usr/local/bin:/usr/bin:/usr/local/sbin:$PATH
export JAVA_HOME=/usr/java/latest
export _JAVA_OPTIONS="-Xms1126M -Xmx1126M"

export ORACLE_PWD=`cat /vagrant/apex-pwd.log`

# Install ORDS
export ORACLE_BASE=/opt/oracle
export ORDS_HOME=$ORACLE_BASE/ords
export ORDS_CONFIG=$ORACLE_BASE/ords-conf
ORACLE_HOME=$(find /opt/oracle -name dbhomeXE | tail -1); export ORACLE_HOME

mkdir -p $ORDS_HOME
cd $ORDS_HOME
INSTALL_DOWNLOAD_PATH=$(ls /vagrant/downloads/ords*.el8.noarch.rpm | tail -1)
yum -y localinstall $INSTALL_DOWNLOAD_PATH
chown -R oracle:oinstall $ORDS_HOME

# Create config directory
su -l oracle -c "mkdir -p $ORDS_CONFIG/logs"

echo "export ORDS_HOME=$ORACLE_BASE/ords" >> /home/oracle/.bashrc
echo "export ORDS_CONFIG=$ORACLE_BASE/ords-conf" >> /home/oracle/.bashrc

# Fix permissions on ORDS standalone directories
chown -R oracle:oinstall $ORACLE_BASE/ords-conf

# cat > $ORDS_HOME/params/ords_params.properties << EOF
# db.hostname=localhost
# db.port=1521
# # CUSTOMIZE db.servicename
# db.servicename=${ORACLE_PDB}
# b.username=APEX_PUBLIC_USER
# db.password=${ORACLE_PWD}
# migrate.apex.rest=false
# plsql.gateway.add=true
# rest.services.apex.add=true
# rest.services.ords.add=true
# schema.tablespace.default=SYSAUX
# schema.tablespace.temp=TEMP
# sys.user=sys
# sys.password=${ORACLE_PWD}
# standalone.mode=TRUE
# standalone.http.port=8080
# standalone.use.https=false
# # CUSTOMIZE standalone.static.images to point to the directory 
# # containing the images directory of your APEX distribution
# standalone.static.images=${ORACLE_HOME}/apex/images
# user.apex.listener.password=${ORACLE_PWD}
# user.apex.restpublic.password=${ORACLE_PWD}
# user.public.password=oracle
# user.tablespace.default=SYSAUX
# user.tablespace.temp=TEMP
# EOF

su -l oracle -c "${ORDS_HOME}/bin/ords --config ${ORDS_CONFIG} install \
    --log-folder ${ORDS_CONFIG}/logs \
    --admin-user SYS \
    --db-hostname localhost \
    --db-port 1521 \
    --db-servicename ${ORACLE_PDB} \
    --schema-tablespace SYSAUX \
    --schema-temp-tablespace TEMP \
    --feature-db-api true \
    --feature-rest-enabled-sql true \
    --feature-sdw true \
    --gateway-mode proxied \
    --gateway-user APEX_PUBLIC_USER \
    --proxy-user \
    --password-stdin <<EOF
${ORACLE_PWD}
${ORACLE_PWD}
EOF"

su -l oracle -c "ords --config ${ORDS_CONFIG} config set standalone.static.path ${ORACLE_HOME}/apex/images"
su -l oracle -c "ords --config ${ORDS_CONFIG} config set standalone.mode TRUE"
su -l oracle -c "ords --config ${ORDS_CONFIG} config set standalone.http.port 8080"
#su -l oracle -c "ords --config ${ORDS_CONFIG} config set standalone.use.https false"

echo 'INSTALL ORDS: Oracle Rest Data Services configuration and installation completed'

# Start ORDS service
cat > /etc/systemd/system/ords.service << EOF
[Unit]
Description=Start Oracle REST Data Services
After=oracle-xe-21c.service

[Service]
User=oracle
ExecStart=/opt/oracle/ords/bin/ords --config /opt/oracle/ords-conf serve
StandardOutput=syslog
SyslogIdentifier=ords

[Install]
WantedBy=multi-user.target
EOF

# Enable and start ords
systemctl enable --now ords

echo 'INSTALL ORDS: Oracle Rest Data Services started'

# Cleanup ------------------------------------------------------------------------
# Vagrantfile unmounts /vagrant
#rm -f /vagrant/apex-pwd.log
#echo "INSTALL ORDS: Cleanup password files"

# Results ------------------------------------------------------------------------
echo ""
echo "INSTALL ORDS: APEX/ORDS Installation Completed";
echo "INSTALL ORDS: You can access APEX by your Host Operating System at following URL:";
echo "INSTALL ORDS: http://localhost:8080/ords/";
echo "INSTALL ORDS: Access granted with:";
echo "INSTALL ORDS: Workspace: internal";
echo "INSTALL ORDS: Username:  admin";
echo "INSTALL ORDS: Password:  ${ORACLE_PWD}";
echo ""

echo "INSTALL ORDS: Complete"