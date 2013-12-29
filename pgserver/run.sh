#! /bin/bash
case $1 in
psql)
  /bin/su postgres -c \
    '/usr/lib/postgresql/9.1/bin/postgres \
      -D /var/lib/postgresql/9.1/main \
      -c config_file=/etc/postgresql/9.1/main/postgresql.conf &'
  sleep 5
  export PGPASSWORD=docker
  psql -h 127.0.0.1 -p 5432 -d docker -U docker
  ;;
run)
  /bin/su postgres -c \
    '/usr/lib/postgresql/9.1/bin/postgres \
      -D /var/lib/postgresql/9.1/main \
      -c config_file=/etc/postgresql/9.1/main/postgresql.conf'
  ;;
*)
  echo Commands:
  echo "  psql   Run the PostgreSQL server and a psql prompt."
  echo "  run    Run only the PostgreSQL server."
  exit 0
esac
