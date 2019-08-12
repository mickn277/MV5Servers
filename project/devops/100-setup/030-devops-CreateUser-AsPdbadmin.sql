CREATE USER devops IDENTIFIED BY "#PASSWORD#"
	DEFAULT TABLESPACE users
	TEMPORARY TABLESPACE temp;

-- System privledges CONNECT and RESOURCE are granted to APPDEV.
GRANT appdba,appdev TO devops;

-- BugFix: This is needed for EXECUTE IMMEDIATE 'CREATE...';
GRANT create table TO devops;
GRANT create view TO devops;

ALTER USER devops QUOTA UNLIMITED ON users;