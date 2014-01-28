#! /bin/bash

# If no /data is provided, use the container cluster, otherwise /data is
# assumed to be a valid PostgreSQL cluster.
DATA=/var/lib/postgresql/9.1/main
if [ -d "/data" ]; then
  DATA=/data
  chown postgres:postgres -R /data
  chmod 0700 -R /data
fi

case $1 in
psql)
  sudo -u postgres \
    /usr/lib/postgresql/9.1/bin/postgres \
      -D $DATA \
      -c config_file=/etc/postgresql/9.1/main/postgresql.conf &
  sleep 5
  export PGPASSWORD=docker
  psql -h 127.0.0.1 -p 5432 -d docker -U docker
  ;;
run)
  sudo -u postgres \
    /usr/lib/postgresql/9.1/bin/postgres \
      -D $DATA \
      -c config_file=/etc/postgresql/9.1/main/postgresql.conf
  ;;
*)
  echo Commands:
  echo "  psql   Run the PostgreSQL server and a psql prompt."
  echo "  run    Run only the PostgreSQL server."
esac

# Make /data useable again by any user on the host.
# TODO Save the permissions and reset them instead.
if [ -d "/data" ]; then
  chmod 0777 -R /data
fi
