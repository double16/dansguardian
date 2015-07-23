dansguardian
============

Container for DansGuardian, a web content filter.

This container is intended to be used as a base image. The configuration is stock. /etc/dansguardian configuration should be set. A sample blacklist config for shallalist is in /blacklists/bannedsitelist, /blacklists/bannedurllist.

Features:
 - dansguardian + squid + blacklist update from shallalist.de
 - See Copyright at http://www.shallalist.de for use of this container
 - Port 3128 is the content filtered proxy port
 - Port 8123 is the caching only proxy port
 - Port 8124 is the transparent caching only proxy port
 - Port 8125 is a web server hosting the "access denied" page
 - Volume /log for holding log files
 - Volume /cache for holding the squid cache
 - Volume /blacklists for persisting black list updates across re-creating of the container
 - Enviroment SERVERNAME for the name or IP of the proxy server

