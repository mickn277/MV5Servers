# --------------------------------------------------------------------------------
# Example: 
#   Add proxy to VM from host:
# --------------------------------------------------------------------------------

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # Inline shell commands:
  config.vm.provision "shell", inline: <<-SHELL
    apt-get install -y avahi-daemon libnss-mdns
  SHELL
  
end