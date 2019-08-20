@REM SETLOCAL

@REM --------------------------------------------------------------------------------
@REM Purpose:
@REM  Backups up directoories under a vagrant directory.
@REM  .vagrant\ directory to backup.
@REM  backups\ - this directory is mounted on the VM so internal processes can backup to it,
@REM    which this script then moves the backups off to antoher directory.
@REM Requirements:
@REM  zip.exe (Info-Zip)
@REM --------------------------------------------------------------------------------

@REM --------------------------------------------------------------------------------
@REM Config:
@REM --------------------------------------------------------------------------------

@SET SCRIPTNAME=%~nx0
@SET CURRENTDIR=%~dp0
@SET BASEDIR=%CURRENTDIR%..\

@REM --------------------------------------------------------------------------------
@REM Main:
@REM --------------------------------------------------------------------------------


copy "%BASEDIR%comstore\provision-scripts\*.sh" "%BASEDIR%Vagrant-Docker-Host\provision-scripts\"
@REM copy "%BASEDIR%comstore\provision-scripts\*.sh" "%BASEDIR%Vagrant-OpenSense-Firewall\provision-scripts\"
copy "%BASEDIR%comstore\provision-scripts\*.sh" "%BASEDIR%Vagrant-OracleApex19c-XE18c\provision-scripts\"
copy "%BASEDIR%comstore\provision-scripts\*.sh" "%BASEDIR%Vagrant-Postgres\provision-scripts\"
