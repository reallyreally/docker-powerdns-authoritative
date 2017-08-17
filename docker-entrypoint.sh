#!/usr/bin/env sh

echo "Starting $0"

if [ -f powerdns_create.sql ]; then
  cp /etc/pdns/pdns.conf /etc/pdns/pdns.conf.orig
  sed -i "s|^# launch=|# launch=\n#\t\n# Added by Dockerfile\nlaunch=gmysql\ngmysql-host=${MYSQL_HOST}\ngmysql-user=${MYSQL_USERNAME}\ngmysql-dbname=${MYSQL_DATABASE}\ngmysql-password=${MYSQL_PASSWORD}\n|g" /etc/pdns/pdns.conf
  sed -i "s|^# webserver-password=|# webserver-password=\n#\t\n# Added by Dockerfile\nwebserver-password=${WEBSERVER_PASSWORD}|g" /etc/pdns/pdns.conf
  set +e
  mysql --user="${MYSQL_USERNAME}" --password="${MYSQL_PASSWORD}" --host="${MYSQL_HOST}" "${MYSQL_DATABASE}" < powerdns_create.sql || :
  set -e
  rm powerdns_create.sql
fi

if [ ! -z $DEBUG ]; then
  /usr/sbin/pdns_server --daemon=no --guardian=no --loglevel=9 --log-dns-details=yes
else
  /usr/sbin/pdns_server --daemon=no --guardian=yes
fi
