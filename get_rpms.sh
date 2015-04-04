#!/bin/bash

# Downloads all of the required rpm files from my dropbox account

function get_file() {
	SRC="$1"
	DEST="$2"

	if [ -e "$DEST" ]; then
		echo "$DEST already exists...skipping...";
	else
		echo wget -O "$DEST" "$SRC"
	fi;
}

BASE_DIR=$(dirname $0);

get_file "https://www.dropbox.com/s/rf664vfeaxl8jla/zookeeper-3.4.6-1.fc21.noarch.rpm?dl=1" "$BASE_DIR/roles/zookeeper/files/zookeeper-3.4.6-1.fc21.noarch.rpm";
get_file "https://www.dropbox.com/s/t8eoculloa15c5u/solr-5.0.0-1.fc21.noarch.rpm?dl=1" "$BASE_DIR/roles/solr/files/solr-5.0.0-1.fc21.noarch.rpm";
get_file "https://www.dropbox.com/s/ax5pax6bp9m6vw4/hadoop-2.6.0-1.fc21.x86_64.rpm?dl=1" "$BASE_DIR/roles/hadoop/files/hadoop-2.6.0-1.fc21.x86_64.rpm";
get_file "https://www.dropbox.com/s/dnt92fy0pemhkji/hbase-1.0.0-1.fc21.x86_64.rpm?dl=1" "$BASE_DIR/roles/hbase/files/hbase-1.0.0-1.fc21.x86_64.rpm";
get_file "https://www.dropbox.com/s/q11f80l422b3f4g/pig-0.14.0-1.fc21.noarch.rpm?dl=1" "$BASE_DIR/roles/pig/files/pig-0.14.0-1.fc21.noarch.rpm";
