# -*- mode: ruby -*-
# vi: set ft=ruby :

# Creates a set of VMs that will utilize a private network
# and will have properly configured /etc/hosts files.
#
# Below are a set of variables you can edit to alter the VMs
# that will be created.

# How much memory (MB) to give each VM.
vm_memory = "6000"

# How many CPUs to give each VM.
vm_cpus = "2"

# The id suffixes for every created VM.
# Integers are used to sync up hostnames and ip addresses.
# Extend the integer range if you want to create more nodes.
#
# WARNING: If you change this range, you will need to update
# the Ansible inventory file!
#
# Do not let this range exceed (1..99) due to the use of
# these numbers in IP addresses.
vm_ids = (1..2)

# The prefix for every created VM.
# All VMs will use this prefix with the id appended to the end.
#
# WARNING: If you change this value, you will need to update the
# Ansible inventory file!
#
# EX: A prefix of "vm-grid-" will result in machines named like
# vm-grid-1, vm-grid-2, etc.
vm_name_prefix = "vm-grid-"

# The three byte IP subnet that every VM will use.
# Every VM will have an ip of "{private_ip_prefix}.1{id}".
#
# EX1: vm-grid-1 with a private_ip_prefix of 192.168.122
# will have a final ip of 192.168.122.11
#
# EX2: vm-grid-2 will have a final ip of 192.168.122.12.
private_ip_prefix = "192.168.122"

Vagrant.configure(2) do |config|
	config.vm.box = "chef/centos-7.0"
	config.vm.provider "virtualbox" do |vb|
		vb.memory = vm_memory
		vb.cpus = vm_cpus
	end
	
	# Provision the /etc/hosts file for all VMs
	vm_ids.each do |i|
		vm_name = "#{vm_name_prefix}#{i}"
		ip_address = "#{private_ip_prefix}.1#{i}"
		config.vm.provision "shell", inline: "echo '#{ip_address}	#{vm_name}' >> /etc/hosts"
	end

	# The first node becomes the primary node
	is_primary = true;
	vm_ids.each do |i|
		vm_name = "#{vm_name_prefix}#{i}"
		ip_address = "#{private_ip_prefix}.1#{i}"
		config.vm.define vm_name, primary: is_primary do |node|
			node.vm.network "private_network", ip: ip_address
			node.vm.hostname = vm_name
		end
		is_primary = false;
	end

end