# Windows powershell.exe

# Requirements:
#   vagrant-proxyconf is installed by Vagrantfile if needed.

$env:http_proxy="http://#USERNAME#:#PASSWORD#@#PROXY_HOSTNAME#:#PROXY_PORT#"
$env:https_proxy=$env:http_proxy
$env:no_proxy="127.0.0.1"
$env:VAGRANT_HTTP_PROXY=$env:http_proxy
$env:VAGRANT_NO_PROXY=$env:no_proxy

echo "Run: vagrant up"
