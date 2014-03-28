from ubuntu:12.04
maintainer Vo Minh Thu <noteed@gmail.com>

run echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list # 20103-08-24
run apt-get update
run apt-get install -q -y language-pack-en
run update-locale LANG=en_US.UTF-8

run apt-get install -q -y vim

# Install Postfix.
run apt-get install -q -y postgresql-client-9.1
