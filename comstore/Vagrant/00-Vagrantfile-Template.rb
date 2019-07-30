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

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
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