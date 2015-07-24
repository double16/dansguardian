curl ${CURL_OPTS} --proxy http://${TARGET}:${PORT_FILTERED} http://adservices.google.com/ | grep -qi "access denied" >/dev/null
