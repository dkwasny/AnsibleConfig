#!/bin/bash

echo "Stopping hive";
/home/admin/daemons/hive-stop.sh;
echo "Stopping hadoop";
/home/admin/stacks/hadoop-stop.sh;
