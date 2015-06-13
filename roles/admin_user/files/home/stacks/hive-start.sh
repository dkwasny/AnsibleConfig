#!/bin/bash

echo "Starting hadoop";
/home/admin/stacks/hadoop-start.sh;
echo "Starting hive";
/home/admin/daemons/hive-start.sh;
