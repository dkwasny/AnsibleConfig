#!/bin/bash

# Some commands I have to run whenever starting with a fresh HDFS.
# I'm probably doing something wrong here...

sudo -u hdfs hdfs dfs -mkdir -p /tmp;
sudo -u hdfs hdfs dfs -chown hdfs:hdfs /tmp;
sudo -u hdfs hdfs dfs -chmod -R 777 /tmp;

sudo -u hdfs hdfs dfs -mkdir -p /user
sudo -u hdfs hdfs dfs -chmod 777 /user;
