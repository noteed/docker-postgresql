#! /bin/bash

# Start the PostgreSQL Docker image `pgserver` and drop into a psql prompt.
# Exiting psql will kill the container.
# This could be simplified as `docker run -t -i -rm=true pgserver psql`.

CONTAINER=$(docker run -d \
  pgserver \
  /bin/su postgres -c '/usr/lib/postgresql/9.1/bin/postgres \
    -D /var/lib/postgresql/9.1/main \
    -c config_file=/etc/postgresql/9.1/main/postgresql.conf')
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
