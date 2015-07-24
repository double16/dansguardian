curl ${CURL_OPTS} --proxy http://${TARGET}:${PORT_CACHED} http://www.google.com/ | grep -qi "Google Search" >/dev/null
