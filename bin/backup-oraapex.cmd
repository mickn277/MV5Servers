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

@REM Copyright (c) 1990-2009 Info-ZIP - Type 'zip "-L"' for software license.
@REM Usage:
@REM zip [-options] [-b path] [-t mmddyyyy] [-n suffixes] [zipfile list] [-xi list]
@REM 
@REM   The default action is to add or replace zipfile entries from list, which
@REM   can include the special name - to compress standard input.
@REM   If zipfile and list are omitted, zip compresses stdin to stdout.
@REM   -f   freshen: only changed files  -u   update: only changed or new files
@REM   -d   delete entries in zipfile    -m   move into zipfile (delete OS files)
@REM   -r   recurse into directories     -j   junk (don't record) directory names
@REM   -0   store only                   -l   convert LF to CR LF (-ll CR LF to LF)
@REM   -1   compress faster              -9   compress better
@REM   -q   quiet operation              -v   verbose operation/print version info
@REM   -c   add one-line comments        -z   add zipfile comment
@REM   -@   read names from stdin        -o   make zipfile as old as latest entry
@REM   -x   exclude the following names  -i   include only the following names
@REM   -F   fix zipfile (-FF try harder) -D   do not add directory entries
@REM   -A   adjust self-extracting exe   -J   junk zipfile prefix (unzipsfx)
@REM   -T   test zipfile integrity       -X   eXclude eXtra file attributes
@REM   -!   use privileges (if granted) to obtain all aspects of WinNT security
@REM   -$   include volume label         -S   include system and hidden files
@REM   -e   encrypt                      -n   don't compress these suffixes
@REM   -h2  show more help

@REM --------------------------------------------------------------------------------
@REM Config:
@REM --------------------------------------------------------------------------------

@SET VAGRANTHOST=Vagrant-XE18c-Apex19c
@IF NOT "%1"=="" SET VAGRANT=%1

@SET SCRIPTNAME=%~nx0
@SET CURRENTDIR=%~dp0
@SET BACKUPDIR=C:\var\backups\MarvinV5\
@SET LOGFILE=C:\var\backups\backup-%VAGRANTHOST%.log

@REM The script was coppied to this location during the build
@SET V_COMMAND=sudo -u oracle /home/oracle/bin/backup-OraXE18c-full-offline.sh

@REM --------------------------------------------------------------------------------
@REM Main:
@REM --------------------------------------------------------------------------------

@ECHO LOGSTART %SCRIPTNAME% BACKUPS ^"Backup %VAGRANTHOST%^" > "%LOGFILE%""

vagrant ssh %VAGRANTHOST% --command "%V_COMMAND%"

:STARTCOPYLOCAL
cd "%CURRENTDIR%..\%VAGRANTHOST%\"

@IF NOT EXIST "%BACKUPDIR%%VAGRANTHOST%\" mkdir "%BACKUPDIR%%VAGRANTHOST%\"

@SET ZIPOPTS=
@SET ZIPFILE=%BACKUPDIR%%VAGRANTHOST%\.vagrant.zip
@IF EXIST "%ZIPFILE%" @SET ZIPOPTS=-u
zip -r -S %ZIPOPTS% "%ZIPFILE%" ".vagrant"
@IF EXIST "%ZIPFILE%" @ECHO LOGINFO %SCRIPTNAME% BACKUPS ^"completed zipping '%ZIPFILE%'^" >> "%LOGFILE%""
@IF NOT EXIST "%ZIPFILE%" @ECHO LOGERROR %SCRIPTNAME% BACKUPS ^"'%ZIPFILE%' not found^" >> "%LOGFILE%""

@SET ZIPOPTS=
@SET ZIPFILE=%BACKUPDIR%%VAGRANTHOST%\guest-backups.zip
@IF EXIST "%ZIPFILE%" @SET ZIPOPTS=-u
zip -r -S %ZIPOPTS% "%ZIPFILE%" "guest-backups"
@IF EXIST "%ZIPFILE%" @ECHO LOGINFO %SCRIPTNAME% BACKUPS ^"completed zipping '%ZIPFILE%'^" >> "%LOGFILE%""
@IF NOT EXIST "%ZIPFILE%" @ECHO LOGERROR %SCRIPTNAME% BACKUPS ^"'%ZIPFILE%' not found^" >> "%LOGFILE%""

cd "%CURRENTDIR%"
:ENDCOPYLOCAL

@ECHO LOGCOMPL %SCRIPTNAME% BACKUPS ^"Backup %VAGRANTHOST%^" >> "%LOGFILE%""