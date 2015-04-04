AnsibleConfig
=============
A reimplementation of [PuppetConfig](https://github.com/dkwasny/PuppetConfig) with [Ansible](http://www.ansible.com/home) instead of Puppet.
Puppet is a fine technology, but is a little too much for my needs.
I found myself only using puppet in --no-daemonize mode and never using it as a real persistent daemon.
Ansible seems to be geared toward this "daemon-less" and "on-demand" model.
Ansible's use of SSH instead of a custom daemon also simplifies VM setup.

Like [PuppetConfig](https://github.com/dkwasny/PuppetConfig), this repo is inteded to target RHEL/Centos 7 guest VMs.
To make life easier, all VMs will open up all 192.168.122.0/24 traffic.

[Vagrant](https://www.vagrantup.com/) can be used to quickly get you some VMs.
The playbook expects a working DNS/hosts file, which [Vagrantfile](Vagrantfile) will setup for you.

If you want to change VM names or use a different number of VMs, then you will need to modify the [Vagrantfile](Vagrantfile) and [Ansible's inventory file](inventory) appropriately.

Setup VMs via Vagrant
---------------------
    vagrant up --provider virtualbox
Only the Virtualbox provider will get the correct memory and CPU VM settings.

Run Ansible (from the host machine)
-----------------------
1. The host machine will need to have a working DNS/hosts file that points to your VMs.
1. Copy your SSH key to the vagrant user on all VMs.

        # This is just an example command
        for i in 1 2 3 4; do ssh-copy-id vagrant@vm-grid-$i; done;

1. Execute the playbook.

        ansible-playbook -i inventory site.yaml

Run Ansible (from one of the VMs)
---------------------
1. SSH into the VM you wish to run Ansible from and clone this repo.
1. Copy the vagrant user's SSH key to all VMs (including the one you are on)

        # This is just an example command
        for i in 1 2 3 4; do ssh-copy-id vagrant@vm-grid-$i; done;

1. Execute the playbook

    ansible-playbook -i inventory site.yaml

Daemons
-----------
To operate on a daemon, execute **sudo systemctl \<start|stop|status\> \<DAEMON_NAME\>**.
Because of how I use systemd to manage daemons, most all daemon logs will end up in systemd's journal instead of being separate files in /var/log.
To read the logs for a particular daemon, execute **sudo journalctl -u \<DAEMON_NAME\>**.
Here is a list of all installed daemons.
* hdfs-namenode
* hdfs-secondarynamenode
* hdfs-datanode
* yarn-resourcemanager
* yarn-nodemanager
* yarn-mrhistoryserver
  * This is really for MapReduce, but I'm rolling it up with the other yarn daemons.
* zookeeper
* hbase-master
* hbase-regionserver
* solr

Administration Scripts
----------
In the home of the admin user on every node you will find a **daemons** and **stacks** folder.
These folders will contain startup and shutdown scripts for their respective domains.
The scripts will stop daemons in the opposite order they are started to help prevent issues.
You should ideally be able to run these scripts from any node within the grid, though you will get less "known_hosts" issues if you stick to one node.

The **daemons** scripts are meant to only turn on a small set of daemons for minimmal functionality.
Turning on a single daemon may result in failure (i.e. starting hbase before hdfs).

The **stacks** scripts are meant to turn on a logical grouping of **daemons** scripts that enable a funcitonal grid.

Here is a list of the stacks I have setup so far.
* hadoop: Starts all hdfs and yarn daemons
* hbase: Starts all hdfs, yarn, zookeeper and hbase daemons
* solrcloud: Starts all hdfs, yarn, zookeeper and solr daemons.
* all: Starts all the things!

.goeshere Files
-----------
There are files in the repo with a suffix of **.goeshere**.
This files are markers meant to tell you that the real file "goes here".
These files are just too big to be reasonably stored in a GitHub repo, and can be found on [Google Drive](https://drive.google.com/folderview?id=0BxpgL9f7eLyfUHhqWlRtRHRQS28&usp=sharing).

Custom RPM Files
-----------
I will be creating my own RPMs unless I am able to find one of the latest version.
You can find the **.spec** and systemd **.service** files for these RPMs in [SpecFiles](https://github.com/dkwasny/SpecFiles).
The binaries within the provided RPMs may be compiled from source if the released binaries do not fit my needs.
The custom RPMs SHOULD be usable on their own, but some minor configuration may be needed if you do not run them through systemd.
