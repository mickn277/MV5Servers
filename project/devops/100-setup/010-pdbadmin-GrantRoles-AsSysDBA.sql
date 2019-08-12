/* --------------------------------------------------------------------------------
Purpose:
This script grants DBA role to pdbadmin so that one user can perform all 
administrative tasks for the database.


sqlplus '/ as sysdba'
connect sys as sysdba
SQL>
-------------------------------------------------------------------------------- */

ALTER SESSION SET CONTAINER = XEPDB1;

set pagesize 2000
set linesize 300

-- For daily DBA work, the role DBA (on PDB-level) is missing.
GRANT dba TO pdbadmin;

GRANT select ON sys.v_$session TO pdbadmin WITH GRANT OPTION;
GRANT select ON sys.v_$instance TO pdbadmin WITH GRANT OPTION;

-- Check PDBADMIN has dba,pdb_dba roles:
SELECT con_id,grantee,granted_role 
FROM cdb_role_privs
WHERE grantee IN ('PDBADMIN');

SELECT * FROM role_tab_privs WHERE role IN ('DBA','PDB_DBA') ORDER BY role DESC;
SELECT * FROM role_sys_privs WHERE role IN ('DBA','PDB_DBA') ORDER BY role DESC;