#!/bin/sh

if [ -n "$TEST" ]; then
	echo "Skipping blacklist update because TEST is defined"
	exit 0
fi

BLACKLISTDIR=/blacklists
BLDIR=/var/lib
BLFILE=shallalist.tar.gz
mkdir -p ${BLACKLISTDIR}
# http://www.shallalist.de/Downloads/shallalist.tar.gz

find ${BLDIR} -maxdepth 1 -name "${BLFILE}" -mtime -5 | grep "." -c - >/dev/null || wget -N -nd -q -P ${BLDIR} http://www.shallalist.de/Downloads/${BLFILE} || exit 1
( cd ${BLDIR} ; tar xozf ${BLDIR}/${BLFILE} )
rm -rf ${BLACKLISTDIR}/*
mv ${BLDIR}/BL/* ${BLACKLISTDIR}
chmod 755 -R ${BLACKLISTDIR}
find ${BLACKLISTDIR} -name "domains" | sed 's/\(.*\)/.Include<\1>/' > ${BLACKLISTDIR}/bannedsitelist
find ${BLACKLISTDIR} -name "urls" | sed 's/\(.*\)/.Include<\1>/' > ${BLACKLISTDIR}/bannedurllist
killall -HUP dansguardian 2>/dev/null || true

