/* --------------------------------------------------------------------------------
Purpose:
Create appdev and appdba roles to grant to any created schema/owner.
--------------------------------------------------------------------------------*/

-- Show non-default users
SELECT username from all_users WHERE username NOT IN ('SYS','AUDSYS','SYSTEM','SYSBACKUP','SYSDG','SYSKM','SYSRAC','OUTLN','XS$NULL','GSMADMIN_INTERNAL','GSMUSER','DIP','REMOTE_SCHEDULER_AGENT','DBSFWUSER','ORACLE_OCM','SYS$UMF','DBSNMP','APPQOSSYS','GSMCATUSER','GGSYS','XDB','ANONYMOUS','WMSYS','DVSYS','OJVMSYS','CTXSYS','ORDSYS','ORDDATA','ORDPLUGINS','SI_INFORMTN_SCHEMA','MDSYS','OLAPSYS','MDDATA','LBACSYS','DVF','HR');

-- Check PDBADMIN has dba,pdb_dba roles:
SELECT con_id,grantee,granted_role 
FROM cdb_role_privs 
WHERE grantee IN ('PDBADMIN','APPDEV','APPDBA');

DROP ROLE appdev;
DROP ROLE appdba;

-- ORA-01919

CREATE ROLE appdev;

GRANT connect, resource TO appdev;
GRANT alter session TO appdev;
GRANT create cluster TO appdev;
GRANT create dimension TO appdev;
GRANT create indextype TO appdev;
GRANT create library TO appdev;
GRANT create materialized view TO appdev;
GRANT create operator TO appdev;
GRANT create procedure TO appdev;
GRANT create sequence TO appdev;
GRANT create session TO appdev;
GRANT create synonym TO appdev;
GRANT create table TO appdev;
GRANT create trigger TO appdev;
GRANT create type TO appdev;
GRANT create view TO appdev;
GRANT query rewrite TO appdev;

CREATE ROLE appdba;

GRANT appdev TO appdba;
GRANT create external job TO appdba;
GRANT create job TO appdba;
GRANT create database link TO appdba;
GRANT select ON sys.v_$session TO appdba;
GRANT select ON sys.v_$instance TO appdba;