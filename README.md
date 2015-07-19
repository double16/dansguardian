dansguardian
============

Container for DansGuardian, a web content filter.

Features:
 - dansguardian + squid + blacklist update from shallalist.de
 - See Copyright at http://www.shallalist.de for use of this container
 - Port 3128 is the content filtered proxy port
 - Port 8123 is the caching only proxy port
 - Port 8124 is the transparent caching only proxy port
 - Volume /log for holding log files
 - Volume /cache for holding the squid cache
 - Volume /blacklists for persisting black list updates across re-creating of the container

