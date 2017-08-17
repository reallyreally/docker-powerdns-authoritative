# docker-powerdns-authoritative
Docker Autobuild for PowerDNS-Authoritative (using MySQL)

Run with something like:
```docker run --env MYSQL_HOST=192.168.0.100 --env MYSQL_DATABASE=powerdns_dev --env MYSQL_USERNAME=powerdns_devuser --env MYSQL_PASSWORD=difficultpassword --env WEBSERVER_PASSWORD=trickypassword --env API_KEY=fancyapikey -p 53:53 -p 53:53/udp -p 8081:8081 -d really/powerdns-authoritative-mysql:latest```
