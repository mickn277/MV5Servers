@SETLOCAL

@SET SCRIPTNAME=%~nx0
@SET CURRENTDIR=%~dp0

@FOR /F "tokens=5" %%G IN ('vagrant global-status^|find /I "poweroff"') DO @(
	cd %%G
	vagrant up
)
@FOR /F "tokens=5" %%G IN ('vagrant global-status^|find /I "aborted"') DO @(
	cd %%G
	vagrant up
)
vagrant global-status

