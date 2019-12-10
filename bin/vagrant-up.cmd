@SETLOCAL

@SET SCRIPTNAME=%~nx0
@SET CURRENTDIR=%~dp0

@REM vagrant global-status

@FOR /F "tokens=2,5" %%G IN ('vagrant global-status^|find /I "aborted"') DO @(
	echo vagrant up %%G
	cd %%H
	vagrant up
)

@FOR /F "tokens=2,5" %%G IN ('vagrant global-status^|find /I "poweroff"') DO @(
	echo vagrant up %%G
	cd %%H
	vagrant up
)

vagrant global-status

