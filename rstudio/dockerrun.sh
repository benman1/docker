#!/bin/bash

# for example: 
# ./dockerrun.sh mike 8788
genpasswd() {
	local l=$1
       	[ "$l" == "" ] && l=16
      	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}
USER=$1
PORT=$2
USER=${USER:=rstudio}
PORT=${PORT:=8787}
PASS=$(genpasswd 8)
echo "The password is $PASS"
docker run  -d --link postgresql:postgres --link mongo:mongo -p $PORT:8787 -v /HOME_SHARE/home/$USER:/home/$USER -e USER=$USER -e PASSWORD=$PASS -e USERID=$(id -u $USER) rstudio