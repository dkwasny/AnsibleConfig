AnsibleConfig
=============
A reimplementation of [PuppetConfig](https://github.com/dkwasny/PuppetConfig) with [Ansible](http://www.ansible.com/home) instead of Puppet.
Puppet is a fine technology, but is a little too much for my needs.
I found myself only using puppet in --no-daemonize mode and never using it as a real persistent daemon.
Ansible seems to be geared toward this "daemon-less" and "on-demand" model.
Ansible's use of SSH instead of a custom daemon also simplifies VM setup.

Like [PuppetConfig](https://github.com/dkwasny/PuppetConfig), this repo is inteded to target RHEL/Centos 7 guest VMs.
To make life easier, all VMs will open up all 192.168.32.0/24 traffic.

[Vagrant](https://www.vagrantup.com/) can be used to quickly get you some VMs.
The playbook expects a working DNS/hosts file, which [Vagrantfile](Vagrantfile) will setup for you.

If you want to change VM names or use a different number of VMs, then you will need to modify the [Vagrantfile](Vagrantfile) and [Ansible's inventory file](inventory) appropriately.

[Apache Bigtop](http://bigtop.apache.org/)'s RPM repository is used for downloading all Hadoop packages.

Vagrant-cachier
---------------
I take advantange of [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier) to speed up the provisioning process.<br/>
You must install this plugin to your Vagrant installation and allow NFS traffic between the host machine and VMs to utilize the RPM caching.<br/>
[Vagrantfile](Vagrantfile) will work just fine without this plugin but will end up re-downloading the same packages for each VM.

Setup VMs via Vagrant
---------------------
    vagrant up --provider [virtualbox | libvirt]
Both the virtualbox and [libvirt](https://github.com/pradels/vagrant-libvirt) providers are supported.

**The [Vagrantfile](Vagrantfile) is configured for hosts with 32GB memory.**<br/>
You may need to make local modifications to the Vagrant file for your system.

Vagrant will perform the Ansible provisioning automatically.<br/>
Any further changes to the Ansible provisioning after initializing the VMs will require running Ansible directly.

Run Ansible (from the host machine)
-----------------------
1. The host machine will need to have a working DNS/hosts file that points to your VMs.<br/>
You can use the generated hosts file on any of the VMs as a starting point.

1. Copy your SSH key to the vagrant user on all VMs.

        # This is just an example command
        for i in 1 2 3 4; do ssh-copy-id vagrant@vm-grid-$i; done;

1. Execute the playbook.

        ansible-playbook -i inventory site.yaml

Run Ansible (from one of the VMs)
---------------------
1. Vagrant SSH into the primary vm and clone this repo.

        vagrant ssh

1. Generate a SSH key for the vagrant user.

        ssh-keygen
        # Mash enter until the key is made

1. Copy the vagrant user's SSH key to all VMs (including the one you are on).

        # This is just an example command
        for i in 1 2 3 4; do ssh-copy-id vagrant@vm-grid-$i; done;

1. Execute the playbook.

        ansible-playbook -i inventory site.yaml

Administration Scripts
----------
In the home of the admin user on every node you will find a **daemons** and **stacks** folder.
These folders will contain startup and shutdown scripts for their respective domains.
The scripts will stop daemons in the opposite order they are started to help prevent issues.
You should ideally be able to run these scripts from any node within the grid, though you will get less "known_hosts" issues if you stick to one node.

The **daemons** scripts are meant to only turn on a small set of daemons for minimal functionality.
Turning on a single daemon may result in failure (i.e. starting hbase before hdfs).

The **stacks** scripts are meant to turn on a logical grouping of **daemons** scripts that enable a funcitonal grid.

Here is a list of the stacks I have setup so far.
* hadoop: Starts all hdfs and yarn daemons
* hbase: Starts all hdfs, yarn, zookeeper and hbase daemons
* solrcloud: Starts all hdfs, yarn, zookeeper and solr daemons.
* hive: Starts all hdfs, yarn and Hive daemons.
* all: Starts all the things!
