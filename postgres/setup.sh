#!/bin/bash

PGDATA=${PGDATA:=/var/lib/postgresql/9.3/}

if [ ! -f "$PGDATA"/main/PG_VERSION ]
then
	/usr/lib/postgresql/9.3/bin/initdb -D $PGDATA
fi

/etc/init.d/postgresql restart
