#!/bin/bash
docker run -dit --name mongo -p 27017:27017 -p 8785:28017 -v /data/mongo/mongodb:/var/lib/mongodb -v /data/mongo/logs:/var/log/mongodb mongodb -f /etc/mongod.yml --noauth
