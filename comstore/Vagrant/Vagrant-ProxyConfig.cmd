@REM Windows cmd.exe

@REM Requirements:
@REM  vagrant-proxyconf is installed by Vagrantfile if needed.

@SET http_proxy=http://#USERNAME#:#PASSWORD#@#PROXY_HOSTNAME#:#PROXY_PORT#
@SET https_proxy=%http_proxy%
@SET no_proxy=127.0.0.1
@SET VAGRANT_HTTP_PROXY=%http_proxy%
@SET VAGRANT_NO_PROXY=%no_proxy%

@ECHO Run: vagrant up