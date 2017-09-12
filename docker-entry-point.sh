#!/bin/bash

set -e                                                                                                                            

if [ "$1" == 'ts3server' ]; then
  # create directories
  test -d /data/files || mkdir -p /data/files
  test -d /data/logs || mkdir -p /data/logs

  # fix permissions
  chown -R teamspeak:teamspeak /data
  
  cd /teamspeak
  DATA=(
    files
    logs
    licensekey.dat
    serverkey.dat
    query_ip_whitelist.txt
    query_ip_blacklist.txt
    ts3server.ini
    ts3server.sqlitedb
    ts3server.sqlitedb-shm
    ts3server.sqlitedb-wal
  )
  
  for i in "${DATA[@]}"
  do
    ln -sf /data/"${i}"
  done
  
  export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
  exec su-exec teamspeak "./$@"
fi

exec "$@"
