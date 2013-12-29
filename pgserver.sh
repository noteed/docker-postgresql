#! /bin/bash

# Start the PostgreSQL Docker image `pgserver` and drop into a psql prompt.
# Exiting psql will kill the container.
# This can be simplified as `docker run -t -i -rm=true pgserver psql` although
# the `psql` process will thus run within the container.

CONTAINER=$(docker run -d pgserver run)
CONTAINER_IP=$(docker inspect $CONTAINER | grep IPAddress | awk '{ print $2 }' | tr -d ',"')
echo pgserver:
echo "  container:" $CONTAINER
echo "  address:  " $CONTAINER_IP

# Poll until the database listens on its port.
while ! nc -z $CONTAINER_IP 5432 ; do sleep 1 ; done

# Doesn't seem enough to ensure the database is ready...
# TODO use pg_ctl status ?
sleep 2

export PGPASSWORD=docker
psql -h $CONTAINER_IP -p 5432 -d docker -U docker
docker kill $CONTAINER
docker rm $CONTAINER
