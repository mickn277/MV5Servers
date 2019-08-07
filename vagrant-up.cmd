@SETLOCAL

@SET SCRIPTNAME=%~nx0
@SET CURRENTDIR=%~dp0

@REM vagrant global-status

@FOR /F "tokens=2" %%G IN ('vagrant global-status^|find /I "aborted"') DO @(
	SET V_NAME=%%G
	IF NOT "%V_NAME%"=="" ECHO %CURRENTDIR%%V_NAME%

)

@FOR /F "tokens=2" %%G IN ('vagrant global-status^|find /I "poweroff"') DO @(
	SET V_NAME=%%G
	IF NOT "%V_NAME%"=="" ECHO %CURRENTDIR%%V_NAME%
)

@REM vagrant global-status

