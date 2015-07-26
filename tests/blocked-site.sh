curl ${CURL_OPTS} --proxy http://${TARGET}:${PORT_FILTERED} http://doubleclick.net/ | grep -qi "access denied"
