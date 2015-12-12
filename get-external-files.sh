#!/bin/bash

function getFile() {
	SOURCE="$1";
	DEST="$2";

	if [ -e "$DEST" ]; then
		echo "$DEST already exists";
	else
		wget "$SOURCE" -O "$DEST";
	fi;
}

BASE_DIR=$(dirname $0);

getFile http://dev.sencha.com/deploy/ext-2.2.zip $BASE_DIR/roles/oozie/files/ext-2.2.zip;
