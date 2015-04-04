AnsibleConfig
=============
A reimplementation of [PuppetConfig](https://github.com/dkwasny/PuppetConfig) with Ansible instead of Puppet.
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

Run Ansible
-----------
You can run Ansible directly from your host machine if you have a working DNS/hosts file.

Otherwise, you can clone this repo on one of the created VMs and run it from there.
The [Vagrantfile](Vagrantfile) will install Git and Ansible on all VMs for you.

ansible-playbook -i [inventory](inventory) [site.yaml](site.yaml)

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
