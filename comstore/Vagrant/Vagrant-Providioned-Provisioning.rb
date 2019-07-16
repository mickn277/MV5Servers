# --------------------------------------------------------------------------------
# Example: 
#   Hack to test if Vagrant will provision the VM.
#   Use this to ensure the prerequisites exist.
# --------------------------------------------------------------------------------

NAME="default"

# Define tests to determine if we are provisioned and or provisioning 
def provisioned?(provider='virtualbox')
    File.exists?(File.join(File.dirname(__FILE__),".vagrant/machines/#{NAME}/#{provider}/action_provision"))
end
def provisioning?()
  (ARGV.include?("reload") && ARGV.include?("--provision")) || ARGV.include?("provision")
end

if (not provisioned?) || provisioning?
  puts 'run provisioning checks here'
else
  puts 'provisioned and not provisioning, skipping provisioning checks ...'
end