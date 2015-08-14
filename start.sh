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
find /log/squid3 /cache/squid3 -not -user proxy -exec chown proxy {} +
/usr/sbin/squid3 -z -f /etc/squid3/squid.conf
/usr/sbin/squid3 -YC -f /etc/squid3/squid.conf

mkdir -p /log/dansguardian
mkdir -p /cache/dansguardian
find /log/dansguardian /cache/dansguardian -not \( -user dansguardian -a -group dansguardian \) -exec chown dansguardian:dansguardian {} +
/usr/sbin/dansguardian

/etc/init.d/apache2 start

cron

tail -q -F /log/squid3/access.log /log/dansguardian/access.log

squid3 -k shutdown
dansguardian -q
killall cron
/etc/init.d/apache2 stop

