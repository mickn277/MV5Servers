# Oracle Apex22.1 XE21c
A vagrant box that provisions Oracle Database XE 21c with Oracle Application Express 19.1 (APEX) automatically, using Vagrant, an Oracle Linux 8 box and a shell script.

## Prerequisites
1. Install [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://vagrantup.com/)
3. Oracle account for downloads

## Getting started
1. Clone this repository `git clone https://github.com/n2779510/MV5Server`
2. Change into the `Vagrant-OracleApex22.1-XE21c` folder
3. Download the Oracle Database XE 21c installation rpm file from OTN into ./downloads/ folder - first time only:
[https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html)
4. Download the Oracle APEX into this folder - first time only:
[https://www.oracle.com/technetwork/developer-tools/apex/downloads/index.html](https://www.oracle.com/technetwork/developer-tools/apex/downloads/index.html)
5. Download Oracle Rest Data Services (ORDS) into this folder - first time only:
[https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/index.html](https://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/index.html)
4. Run `vagrant up | tee vagrant.log`, this is helpful as the log goes past the 9999 line limit in powershell.
   1. The first time you run this it will provision everything and may take a while. Ensure you have (a good) internet connection as the scripts will update the virtual box to the latest via `yum`.
   2. The Vagrant file allows for customization, if desired (see [Customization](#customization))
5. Connect to the database.
6. You can shut down the box via the usual `vagrant halt` and the start it up again via `vagrant up`.


## Connecting to Oracle

### Configuration
* Hostname: `localhost`
* Port: `1521`
* SID: `XE`
* PDB: `XEPDB1`
* PDBADMIN: `pdbadmin`
* CDB: `CDB$ROOT`
* All passwords are auto-generated and printed on install

### Apex Central http://localhost:8080/ords/
* Workspace: `internal`
* Username: `admin`
* Password: `#PASSWORD#`

### SQLPlus / SQL Developer
* username: `pdbadmin`
* service_name: `XEPDB1`
* Password: `#PASSWORD#`

### EM Console https://localhost:5500/em default PDB
* Username: `sys`
* Password: `#PASSWORD#`
* Container Name: `XEPDB1`
* as sysdba [checked]

### EM Console https://localhost:5500/em default CDB 
* Username: `sys`
* Password: `#PASSWORD#`
* Container Name: `CDB$ROOT`
* as sysdba [checked]

## Other info

* If you need to, you can connect to the machine via `vagrant ssh`.
* You can `sudo su - oracle` to switch to the oracle user.
* The Oracle installation path is `/opt/oracle/` by default.
* On the guest OS, the directory `/scripts` and `/backups` are shared folders and map to wherever you have this file checked out.

### Customization
You can customize your Oracle environment by amending the environment variables in the `Vagrantfile` file.
The following can be customized:
* `ORACLE_CHARACTERSET`: `AL32UTF8`
* `ORACLE_PWD`: `auto generated`
* `SYSTEM_TIMEZONE`: `automatically set (see below)`
  * The system time zone is used by the database for SYSDATE/SYSTIMESTAMP.
  * The guest time zone will be set to the host time zone when the host time zone is a full hour offset from GMT.
  * When the host time zone isn't a full hour offset from GMT (e.g., in India and parts of Australia), the guest time zone will be set to UTC.
  * You can specify a different time zone using a time zone name (e.g., "America/Los_Angeles") or an offset from GMT (e.g., "Etc/GMT-2"). For more information on specifying time zones, see [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

