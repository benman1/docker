FROM ubuntu:latest
MAINTAINER Ben Auffarth

ENV DEBIAN_FRONTEND noninteractive
RUN sed -i 's/exit 101/exit 0/' /usr/sbin/policy-rc.d

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
RUN cp -vf /usr/share/zoneinfo/Europe/London /etc/localtime 

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org=3.0.7 mongodb-org-server=3.0.7 mongodb-org-shell=3.0.7 mongodb-org-mongos=3.0.7 mongodb-org-tools=3.0.7 && \
    echo "mongodb-org hold" | dpkg --set-selections && echo "mongodb-org-server hold" | dpkg --set-selections && \
    echo "mongodb-org-shell hold" | dpkg --set-selections && \
    echo "mongodb-org-mongos hold" | dpkg --set-selections && \
    echo "mongodb-org-tools hold" | dpkg --set-selections

# Expose port 27017 from the container to the host
EXPOSE 27017 28017

VOLUME /var/log/mongodb
VOLUME /var/lib/mongodb

COPY resources/mongod.conf /etc/mongod.conf
COPY resources/mongod.yml /etc/mongod.yml
RUN chown mongodb:mongodb /etc/mongod.yml
RUN chown mongodb:mongodb /etc/mongod.conf
RUN rm -f /var/lib/mongodb/mongod.lock

USER mongodb
# Set usr/bin/mongod as the dockerized entry-point application
ENTRYPOINT ["/usr/bin/mongod"]
