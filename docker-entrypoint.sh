#!/usr/bin/env sh

echo "Starting $0"

if [ -f powerdns_create.sql ]; then
  cp /etc/pdns/pdns.conf /etc/pdns/pdns.conf.orig
  sed -i "s|^# launch=|# launch=\n#\t\n# Added by Dockerfile\nlaunch=gmysql\ngmysql-host=${MYSQL_HOST}\ngmysql-user=${MYSQL_USERNAME}\ngmysql-dbname=${MYSQL_DATABASE}\ngmysql-password=${MYSQL_PASSWORD}\n|g" /etc/pdns/pdns.conf
  if [ ! -z $WEBSERVER_PASSWORD ]; then
    sed -i "s|^webserver=no|# webserver=no\n#\t\n# Added by Dockerfile\nwebserver=yes|g" /etc/pdns/pdns.conf && \
    sed -i "s|^# webserver-address=127.0.0.1|# webserver-address=127.0.0.1\n#\t\n# Added by Dockerfile\nwebserver-address=\:\:|g" /etc/pdns/pdns.conf && \
    sed -i "s|^# webserver-password=|# webserver-password=\n#\t\n# Added by Dockerfile\nwebserver-password=${WEBSERVER_PASSWORD}|g" /etc/pdns/pdns.conf

    if [ ! -z $API_KEY ]; then
      sed -i "s|^webserver=yes|webserver=yes\napi=yes\napi-key=${API_KEY}|g" /etc/pdns/pdns.conf
    fi
  fi
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
