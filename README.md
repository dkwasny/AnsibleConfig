AnsibleConfig
=============
A reimplementation of [PuppetConfig](https://github.com/dkwasny/PuppetConfig) with Ansible instead of Puppet.
Puppet is a fine technology, but is a little too much for my needs.
I found myself only using puppet in --no-daemonize mode and never using it as a real persistent daemon.
Ansible seems to be geared toward this "daemon-less" and "on-demand" model.
Ansible's use of SSH instead of a custom daemon also simplifies VM setup.

Like [PuppetConfig](https://github.com/dkwasny/PuppetConfig), this repo is inteded to target RHEL/Centos 7 guest VMs.
To make life easier, all VMs will open up all 192.168.122.0/24 traffic.

VM Naming Scheme
----------------
vm-grid-<number>

You can really use whatever you want, but some files (/etc/hosts) may use these names explicitly.

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

Network Setup (VirtualBox)
--------------------------
1. Create a new host-only network that has no DHCP server.
	* For the sake of consistency, use 192.168.122.0/24.
	* Ensure the gateway is 192.168.122.1.
1. Give all new VMs a NAT and host-only network adapter.

VM Creation (libvirt)
---------------------
sudo virt-install --connect=qemu:///system -n <name> -r <memory-in-MB> --vcpus=<num-of-cores> --cdrom=/usr/share/libvirt/install-media/CentOS-7.0-1406-x86_64-Minimal.iso --os-variant=rhel7 --disk path=/var/lib/libvirt/images/<name>,size=<side-of-storage-in-GB> -w network=static --graphics vnc

VM Network Configuration
------------------------
1. Change /etc/sysconfig/network-scripts/ifcfg-eth*
	1. Set BOOTPROTO=none
	1. Set ONBOOT=yes
	1. Add IPADDR=192.168.122.1[number-of-vm]
	1. Add NETMASK=255.255.255.0
	1. Add GATEWAY=192.168.122.1 (needed for libvirt)
	1. Add DNS1=192.168.122.1 (needed for libvirt)
