# --------------------------------------------------------------------------------
# Example: 
#   External ssh port config
# --------------------------------------------------------------------------------

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Must specify :id "ssh" so it's recognised as the vagrant ssh port
  config.vm.network :forwarded_port, guest: 22, host: 2201, id: "ssh"

end