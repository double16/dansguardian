dansguardian [![CircleCI](https://circleci.com/gh/double16/dansguardian.svg?style=svg&circle-token=9482bcf116b2564ced24bda33b0876acbbbb5621)](https://circleci.com/gh/double16/dansguardian)
============

Container for DansGuardian, a web content filter.

This container is intended to be used as a base image. The configuration is stock from the Ubuntu packages. `/etc/dansguardian/*` needs to be configured for your use case. This container configuration uses all of the blacklists from shallalist.de, which makes it very restrictive. You might try http://www.myip.com for a site that is not blocked.

A sample blacklist config for shallalist is in `/blacklists/bannedsitelist`, `/blacklists/bannedurllist`. These files are not referenced by the dansguardian config. They are provided to show the total available blacklists provided by shallalist.de and are updated each time the blacklist is downloaded via cron.

Features:
 - dansguardian + squid + blacklist update from shallalist.de
 - See Copyright at http://www.shallalist.de for use of this container
 - Port 3128 is the content filtered proxy port
 - Port 8123 is the caching only proxy port
 - Port 8124 is the transparent caching only proxy port
 - `http://*:8125/reports` holds web usage reports stored at `/log/sarg`
 - Volume `/log` for holding log files
 - Volume `/cache` for holding the squid cache
 - Volume `/blacklists` for persisting black list updates across re-creating of the container
 - Enviroment `SERVERNAME` for the name or IP of the proxy server, by default uses the value of `hostname` in the container

