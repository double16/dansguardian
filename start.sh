#!/bin/bash

# Clear files from previous dirty exit
rm -f /var/run/dansguardian.pid /var/run/squid3.pid

[ -n "${SERVERNAME}" ] || SERVERNAME="$(hostname)"
sed -i "s/YOURSERVER.YOURDOMAIN/${SERVERNAME}:8125/" /etc/dansguardian/dansguardian.conf
echo "ServerName ${SERVERNAME}" >> /etc/apache2/apache2.conf

# Update the blacklists, which may not be populated if the /blacklists volume is mounted as a data container.
# If the downloaded tar ball is recent, then this won't download it again.
/blacklist-update.sh

mkdir -p /log/squid3
mkdir -p /cache/squid3
chown -R proxy /log/squid3 /cache/squid3
/usr/sbin/squid3 -z -f /etc/squid3/squid.conf
/usr/sbin/squid3 -N -YC -f /etc/squid3/squid.conf &

mkdir -p /log/dansguardian
mkdir -p /cache/dansguardian
chown -R dansguardian:dansguardian /log/dansguardian /cache/dansguardian
/usr/sbin/dansguardian &

/etc/init.d/apache2 start

cron

tail -q -F /log/squid3/access.log /log/dansguardian/access.log

/etc/init.d/apache2 stop
killall dansguardian
killall squid3
killall cron

