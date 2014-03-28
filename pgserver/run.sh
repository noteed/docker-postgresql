#! /bin/bash

# Use /data as PostgreSQL cluster if available.
DATA=/var/lib/postgresql/9.1/main
if [ -d "/data" ]; then
  DATA=/data
  chown postgres:postgres -R /data
  chmod 0700 -R /data
fi

# Otherwise use the container cluster.

case $1 in
configure)
  sudo -u postgres \
    /usr/lib/postgresql/9.1/bin/postgres \
      -c data_directory=$DATA \
      -c config_file=/etc/postgresql/9.1/main/postgresql.conf &
  sleep 5
  sudo -u postgres \
    psql -c "ALTER DATABASE docker RENAME to $2"
  sudo -u postgres \
    psql -c "ALTER USER docker RENAME to $3"
  sudo -u postgres \
    psql -c "ALTER USER $3 WITH PASSWORD '$4'"
  ;;
psql)
  sudo -u postgres \
    /usr/lib/postgresql/9.1/bin/postgres \
      -c data_directory=$DATA \
      -c config_file=/etc/postgresql/9.1/main/postgresql.conf &
  sleep 5
  export PGPASSWORD=docker
  psql -h 127.0.0.1 -p 5432 -d docker -U docker
  ;;
restore)
  sudo -u postgres \
    /usr/lib/postgresql/9.1/bin/postgres \
      -c data_directory=$DATA \
      -c config_file=/etc/postgresql/9.1/main/postgresql.conf &
  sleep 5
  export PGPASSWORD=docker
  xz -d --stdout $2 | psql -h 127.0.0.1 -p 5432 -d docker -U docker
  psql -h 127.0.0.1 -p 5432 -d docker -U docker
  ;;
run)
  # Use initial.sh to create /data.
  if [ -f "/initial.sh" ]; then
    /initial.sh $2
    DATA=/data
    chown postgres:postgres -R /data
    chmod 0700 -R /data
    echo Using restored $2.
  fi
  sudo -u postgres \
    /usr/lib/postgresql/9.1/bin/postgres \
      -c data_directory=$DATA \
      -c config_file=/etc/postgresql/9.1/main/postgresql.conf
  ;;
*)
  echo Commands:
  echo "  configure  Reconfigure the database, user, and password."
  echo "  psql       Run the PostgreSQL server and a psql prompt."
  echo "  restore    Restore a cluster dump."
  echo "  run        Run only the PostgreSQL server."
esac

# Make /data useable again by any user on the host.
# TODO Save the permissions and reset them instead.
if [ -d "/data" ]; then
  chmod 0777 -R /data
fi
