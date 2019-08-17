
# Vagrnatfile examples and snippets

#### Vagrant template

```ruby
# --------------------------------------------------------------------------------
# Purpose:
#
# Requirements:
# 
# History:
#
# --------------------------------------------------------------------------------

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# VM name, hostname?
NAME = "Vagrant-#VM_NAME#"
HOSTNAME = "#HOSTNAME#"

# Define tests to determine if we are provisioned and or provisioning 
def provisioned?(provider='virtualbox')
    File.exists?(File.join(File.dirname(__FILE__),".vagrant/machines/#{NAME}/#{provider}/action_provision"))
end
def provisioning?()
    (ARGV.include?("reload") && ARGV.include?("--provision")) || ARGV.include?("provision")
end

# Virtualbox prerequisites
unless Vagrant.has_plugin?("vagrant-reload")
    puts 'Installing vagrant-reload Plugin...'
    system('vagrant plugin install vagrant-reload')
  end
  unless Vagrant.has_plugin?("vagrant-proxyconf")
    puts 'Installing vagrant-proxyconf Plugin...'
    system('vagrant plugin install vagrant-proxyconf')
  end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "#BASEBOX_NAME#"
    config.vm.box_url = "#BASEBOX_URL#"
    config.vm.define NAME
    config.vm.box_check_update = false
    config.vm.hostname = NAME
  
    # Configure VM Properties
    config.vm.provider "virtualbox" do |v|
        v.memory = 512
        v.cpus = 1
        v.name = NAME
        v.customize ["modifyvm", :id, "--audio", "none"] # Prevent VirtualBox from interfering with host audio stack
    end

    # Proxy configuration from host env - optional
    if Vagrant.has_plugin?("vagrant-proxyconf")
        puts "getting Proxy Configuration from Host..."
        if ENV["http_proxy"]
            puts "http_proxy: " + ENV["http_proxy"]
            config.proxy.http     = ENV["http_proxy"]
        end
        if ENV["https_proxy"]
            puts "https_proxy: " + ENV["https_proxy"]
            config.proxy.https    = ENV["https_proxy"]
        end
        if ENV["no_proxy"]
            config.proxy.no_proxy = ENV["no_proxy"]
        end
    end

    # SecFix: Don't map the root of vagrant as the path leads to the private keys etc.
    if provisioned?
        config.vm.synced_folder ".", "/vagrant", disabled: true
    end

    config.vm.synced_folder "scripts/", "/var/scripts"
    config.vm.synced_folder "backups/", "/var/backups"

    #Provisioning?
    config.vm.provision :shell, path: "provisioning-scripts/install-docker.sh"
end
```


#### Vagrant provisioning state, can use this to ensure the prerequisites exist.

```ruby
NAME = "Vagrant-#VM_NAME#"

# Define tests to determine if we are provisioned and or provisioning 
def provisioned?(provider='virtualbox')
    File.exists?(File.join(File.dirname(__FILE__),".vagrant/machines/#{NAME}/#{provider}/action_provision"))
end
def provisioning?()
  (ARGV.include?("reload") && ARGV.include?("--provision")) || ARGV.include?("provision")
end

if (not provisioned?) || provisioning?
  puts 'run not provisioned or provisioning checks here'
  unless !Dir.glob('./downloads/oracle-database-xe-18c*.rpm').empty?
    puts 'downloaded database-preinstall not found'
    exit
  end
else
  puts 'provisioned and not provisioning, skipping provisioning checks ...'
end
```

## Proxy examples

#### Windows batch session proxy config

```batch
@SET http_proxy=http://#USERNAME#:#PASSWORD#@#PROXY_HOSTNAME#:#PROXY_PORT#
@SET https_proxy=%http_proxy%
@SET no_proxy=127.0.0.1
@SET VAGRANT_HTTP_PROXY=%http_proxy%
@SET VAGRANT_NO_PROXY=%no_proxy%

@ECHO Run: vagrant up
```

#### Windows powershell session proxy config

```powershell
$env:http_proxy="http://#USERNAME#:#PASSWORD#@#PROXY_HOSTNAME#:#PROXY_PORT#"
$env:https_proxy=$env:http_proxy
$env:no_proxy="127.0.0.1"
$env:VAGRANT_HTTP_PROXY=$env:http_proxy
$env:VAGRANT_NO_PROXY=$env:no_proxy

echo "Run: vagrant up"
```

#### Vagrant configure proxy from session

```ruby
Vagrant.configure("2") do |config|

  # add proxy configuration from host env - optional
  if Vagrant.has_plugin?("vagrant-proxyconf")
    puts "getting Proxy Configuration from Host..."
    if ENV["http_proxy"]
      puts "http_proxy: " + ENV["http_proxy"]
      config.proxy.http     = ENV["http_proxy"]
    end
    if ENV["https_proxy"]
      puts "https_proxy: " + ENV["https_proxy"]
      config.proxy.https    = ENV["https_proxy"]
    end
    if ENV["no_proxy"]
      config.proxy.no_proxy = ENV["no_proxy"]
    end
  end

end
```

#### Vagrant shell inline

```ruby
Vagrant.configure("2") do |config|
  # Inline shell commands:
  config.vm.provision "shell", inline: <<-SHELL
    apt-get install -y avahi-daemon libnss-mdns
  SHELL
end
```

#### Vagrant ssh config, required to have several vagrants on the same VM host

```ruby
Vagrant.configure("2") do |config|
  # Must specify :id "ssh" so it's recognised as the vagrant ssh port.  default=2222.
  config.vm.network :forwarded_port, guest: 22, host: 2223, id: "ssh"
end
```
