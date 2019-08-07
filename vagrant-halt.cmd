@SETLOCAL

@SET SCRIPTNAME=%~nx0
@SET CURRENTDIR=%~dp0

@FOR /F "tokens=2,5" %%G IN ('vagrant global-status^|find /I "running"') DO @(
	echo vagrant halt %%G
	cd %%H
	vagrant halt
)
vagrant global-status