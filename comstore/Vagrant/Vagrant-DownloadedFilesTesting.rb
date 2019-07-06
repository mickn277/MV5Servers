# --------------------------------------------------------------------------------
# Example: 
#   Downloaded files testing:
# --------------------------------------------------------------------------------

# Tests for downloaded file(s) ...
unless !Dir.glob('./downloads/oracle-database-xe-18c*.rpm').empty?
  puts 'downloaded database-preinstall not found'
  exit
end