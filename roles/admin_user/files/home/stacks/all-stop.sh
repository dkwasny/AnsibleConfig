#!/bin/bash

echo "Stopping oozie";
/home/admin/daemons/oozie-stop.sh;
echo "Stopping hive";
/home/admin/daemons/hive-stop.sh;
echo "Stopping hbase";
/home/admin/daemons/hbase-stop.sh;
echo "Stopping zookeeper";
/home/admin/daemons/zookeeper-stop.sh;
echo "Stopping hadoop";
/home/admin/stacks/hadoop-stop.sh;
