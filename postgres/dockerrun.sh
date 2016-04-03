#!/bin/bash

# for example: 
# ./dockerrun.sh mike 8788
genpasswd() {
	local l=$1
	[ "$l" == "" ] && l=16
	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}
PASS=$(genpasswd 8)
#echo "The password is $PASS"

docker run -d --name postgresql -e PASS=$PASS -v /data/postgres/db:/var/lib/postgresql -v /data/postgres/logs:/var/log/postgresql -p 5432:5432 postgres
