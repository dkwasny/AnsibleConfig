Network Setup
-------------
* For the sake of consistency, use a local network of 192.168.122.0/24.
* Ensure the gateway is 192.168.122.1.

Network Setup (libvirt)
-----------------------
1. Copy /usr/share/libvirt/networks/default.xml to static.xml.
1. Change the name from default to static within static.xml.
1. Remove the DHCP entry in static.xml.
1.  Open up virsh:
	1. net-destroy default
	1. net-autostart --disable default
	1. net-define /usr/share/libvirt/networks/static.xml
	1. net-autostart static
	1. net-start static

Misc Notes
==========

Network Setup (VirtualBox)
--------------------------
1. Create a new host-only network that has no DHCP server.
1. Give all new VMs a NAT and host-only network adapter.

VM Creation (libvirt)
---------------------
sudo virt-install --connect=qemu:///system -n [name] -r [memory-in-MB] --vcpus=[num-of-cores] --cdrom=/usr/share/libvirt/install-media/CentOS-7.0-1406-x86_64-Minimal.iso --os-variant=rhel7 --disk path=/var/lib/libvirt/images/[name],size=[size-of-storage-in-GB] -w network=static --graphics vnc

VM Configuration
------------------------
1. Change /etc/sysconfig/network-scripts/ifcfg-eth0
	* Set BOOTPROTO=none
	* Set ONBOOT=yes
	* Add IPADDR=192.168.122.1[number-of-vm]
	* Add NETMASK=255.255.255.0
	* Add GATEWAY=192.168.122.1 (needed for libvirt)
	* Add DNS1=192.168.122.1 (needed for libvirt)
1. Restart the network
	* systemctl restart network
1. Update all packages
	* yum -y install deltarpm; yum -y update;
1. Restart the machine to pickup any new kernel updates and whatnot.
1. Use ssh-copy-id to add your ssh key to the root user on all VMs
	* ssh-copy-id root@[vm-ip-address]
	* There are safer ways to do this, but I don't care when dealing with toy VMs.
