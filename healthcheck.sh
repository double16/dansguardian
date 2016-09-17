#!/bin/sh -e

TARGET=localhost
TIMEOUT=15
CURL_OPTS="--retry 3 --connect-timeout ${TIMEOUT} --silent --show-error --fail"

PORT_FILTERED=3128
PORT_CACHED=8123
PORT_INTERCEPT=8124
PORT_ACCESSDENIED=8125

nc -z -w ${TIMEOUT} ${TARGET} ${PORT_FILTERED}
nc -z -w ${TIMEOUT} ${TARGET} ${PORT_CACHED}
nc -z -w ${TIMEOUT} ${TARGET} ${PORT_INTERCEPT}
curl ${CURL_OPTS} "http://${TARGET}:${PORT_ACCESSDENIED}/cgi-bin/dansguardian.pl?" | grep -qi "access denied"  >/dev/null

