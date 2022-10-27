import virtualbox

session = virtualbox.Session()
vbox = virtualbox.VirtualBox()
machine = vbox.find_machine("Vagrant-XE21c-Apex22")
# If you want to run it normally:
# proc = machine.launch_vm_process(session, "gui")
# If you want to run it in background:
proc = machine.launch_vm_process(session, "headless", [])
proc.wait_for_completion(timeout=-1)
