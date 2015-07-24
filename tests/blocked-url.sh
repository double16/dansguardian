curl ${CURL_OPTS} --proxy http://${TARGET}:${PORT_FILTERED} http://google.com/adsense | grep -qi "access denied" >/dev/null
