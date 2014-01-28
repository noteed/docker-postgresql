from ubuntu:12.04
maintainer Vo Minh Thu <noteed@gmail.com>

run echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
run apt-get update
run apt-get install -q -y language-pack-en
run update-locale LANG=en_US.UTF-8

run apt-get install -q -y vim

# For https://github.com/dotcloud/docker/issues/2972
run apt-get install -q -y sudo

# Install PostgreSQL
run apt-get install -q -y postgresql-9.1

run sh -c "service postgresql start ; su postgres -c 'createuser -d -r -s docker' ; service postgresql stop"
run sh -c "service postgresql start ; su postgres -c \"psql -c \\\"ALTER USER docker PASSWORD 'docker'\\\"\" ; service postgresql stop"
run sh -c "service postgresql start ; su postgres -c 'createdb -O docker docker' ; service postgresql stop"
run sed -i -e 's/^host *all *all *127.0.0.1\/32 *md5$/host  all  all  0.0.0.0\/0  md5/' /etc/postgresql/9.1/main/pg_hba.conf
run echo "listen_addresses = '*'" >> /etc/postgresql/9.1/main/postgresql.conf

add run.sh /run.sh

entrypoint ["/run.sh"]
