# -*- mode: ruby -*-
# vi: set ft=ruby :

# Creates a set of VMs that will utilize a private network
# and will have properly configured /etc/hosts files.
#
# Below are a set of variables you can edit to alter the VMs
# that will be created.

# How much memory (MB) to give each VM.
# These settings are intended for host machines with 32GB memory.
# This should leave 4GB free for the host OS.
primary_vm_memory = "8500"
secondary_vm_memory = "6500"

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
vm_ids = (1..4)

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
# Every VM will have an ip of "{private_ip_prefix}{id}".
#
# EX1: vm-grid-1 with a private_ip_prefix of 192.168.32.1
# will have a final ip of 192.168.32.11
#
# EX2: vm-grid-2 will have a final ip of 192.168.32.12.
private_ip_prefix = "192.168.32.1"

Vagrant.configure(2) do |config|
	# Base VM setup
	config.vm.box = "centos/7"

	config.vm.provider :virtualbox do |vb|
		vb.cpus = vm_cpus
	end
	config.vm.provider :libvirt do |lv|
		lv.cpus = vm_cpus
	end

	# Disable any default synced folders
	config.vm.synced_folder ".", "/vagrant", disabled: true
	config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

	# Perform Ansible provisioning
	config.vm.provision :ansible do |a|
		a.playbook = "site.yaml"
		a.inventory_path = "inventory"
	end

	# The first node becomes the primary node
	first_node = true
	vm_ids.each do |i|
		is_primary = first_node
		vm_name = "#{vm_name_prefix}#{i}"
		ip_address = "#{private_ip_prefix}#{i}"
		config.vm.provision :shell, inline: "echo '#{ip_address}	#{vm_name}' >> /etc/hosts"
		config.vm.define vm_name, primary: is_primary do |node|
			node.vm.network :private_network, ip: ip_address
			node.vm.hostname = vm_name
			
			# Explicitly remove the 127.0.0.1 -> hostname entry in /etc/hosts.
			# Leaving this causes daemons to listen on 127.0.0.1 instead
			# of the private network defined earlier.
			node.vm.provision :shell, inline: "
				sed -i 's/127\.0\.0\.1[[:space:]]*#{vm_name}/127.0.0.1 /' /etc/hosts
			"
			
			# Primary node specific settings
			if is_primary
				vm_memory = primary_vm_memory
			else
				vm_memory = secondary_vm_memory
			end

			node.vm.provider :virtualbox do |vb|
				vb.memory = vm_memory
			end
			node.vm.provider :libvirt do |lv|
				lv.memory = vm_memory
			end
		end
		first_node = false
	end

	# Utilize vagrant-cachier to limit bandwidth usage
	# when installing pacakges.
	# NFS has to be used to allow bidirectional caching.
	if Vagrant.has_plugin?("vagrant-cachier")
		config.cache.scope = :box
		config.cache.synced_folder_opts = {
			type: :nfs,
			nfs_udp: false,
			nfs_version: 3,
			mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
		}
	end

end
