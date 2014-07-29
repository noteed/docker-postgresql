from noteed/pgserver
maintainer Vo Minh Thu <noteed@gmail.com>

# OpenSSH for the `scp` binary.
run apt-get -q -y install openssh-client

# Private SSH key to access the `scp`. These two files are given as an example:
# configured images should overwrite this two files.
add insecure_id_rsa /var/lib/postgresql/9.1/insecure_id_rsa
add archive.sh /var/lib/postgresql/9.1/archive.sh
run chown postgres:postgres /var/lib/postgresql/9.1/insecure_id_rsa
run chown postgres:postgres /var/lib/postgresql/9.1/archive.sh

# No idea why with `run su postgres -c` this is not needed but with
# `-u postgres run` this is needed.
run rm /var/lib/postgresql/9.1/main/server.crt
run rm /var/lib/postgresql/9.1/main/server.key
run cp /etc/ssl/certs/ssl-cert-snakeoil.pem /var/lib/postgresql/9.1/main/server.crt
run cp /etc/ssl/private/ssl-cert-snakeoil.key /var/lib/postgresql/9.1/main/server.key
run chown postgres:postgres /var/lib/postgresql/9.1/main/server.crt
run chown postgres:postgres /var/lib/postgresql/9.1/main/server.key

# Enable continuous archiving, and archive WAL segments using `scp`.
run echo "wal_level = hot_standby" >> /etc/postgresql/9.1/main/postgresql.conf
run echo "archive_mode = on" >> /etc/postgresql/9.1/main/postgresql.conf
run echo "archive_command = '/var/lib/postgresql/9.1/archive.sh %p %f'" >> /etc/postgresql/9.1/main/postgresql.conf
# run echo "log_error_verbosity = VERBOSE" >> /etc/postgresql/9.1/main/postgresql.conf
