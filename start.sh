#!/bin/bash

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

cron

tail -q -F /log/squid3/access.log /log/dansguardian/access.log

