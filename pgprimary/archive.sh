#! /bin/bash

scp -B -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  -i /var/lib/postgresql/9.1/insecure_id_rsa \
  $1 scp@reesd.com:noteed/wal-segments/$2
