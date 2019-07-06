PROMPT 'Do not allow dangerous commands to run automatically, exiting'
QUIT;
-- --------------------------------------------------------------------------------
-- Requirements:
-- --------------------------------------------------------------------------------
Server memory must be set to 3072 MB or the database will fail to start with MEMORY_TARGET=2G


-- --------------------------------------------------------------------------------
-- Rollback Prep:
-- --------------------------------------------------------------------------------
cd $ORACLE_HOME/dbs
sqlplus '/ as sysdba'
SQL>
create pfile from spfile;
exit
ll $ORACLE_HOME/dbs/initXE.ora

-- --------------------------------------------------------------------------------
-- PGA Looks Good:
-- --------------------------------------------------------------------------------
sqlplus '/ as sysdba'
-- Set the dynamic parameters. Assuming Oracle has full control.
ALTER SYSTEM SET PGA_AGGREGATE_TARGET=0 SCOPE=SPFILE;
ALTER SYSTEM SET SGA_MAX_SIZE=0 SCOPE=SPFILE;
ALTER SYSTEM SET SGA_TARGET=0 SCOPE=SPFILE;
ALTER SYSTEM SET MEMORY_MAX_TARGET=2G SCOPE=SPFILE;
-- For Telstra
ALTER SYSTEM SET MEMORY_TARGET=2G SCOPE=SPFILE;

shutdown immediate
startup

-- --------------------------------------------------------------------------------
-- Memory:
-- --------------------------------------------------------------------------------
show parameter memory
show parameter sga
show parameter pga

-- --------------------------------------------------------------------------------
-- Show installed featues:
-- --------------------------------------------------------------------------------
SET PAGESIZE 9990
SET LINESIZE 300
COLUMN comp_name FORMAT A40
COLUMN schema FORMAT A20
SELECT con_id, comp_name, version, status, schema FROM cdb_registry ORDER BY con_id, comp_name;

-- --------------------------------------------------------------------------------
-- Show schema sizes:
-- --------------------------------------------------------------------------------
SELECT s.con_id, s.owner, sum(s.bytes)/1024/1024 MByte
FROM cdb_segments s, cdb_users u
WHERE s.owner = u.username
AND s.con_id = u.con_id
AND u.oracle_maintained != 'Y'
GROUP BY s.con_id,s.owner
ORDER BY 1,2;

-- --------------------------------------------------------------------------------
-- Rollback:
-- --------------------------------------------------------------------------------
cd $ORACLE_HOME/dbs
sqlplus '/ as sysdba'

SQL>
startup pfile='initXE.ora';
create spfile from pfile;
shutdown immediate
startup