curl ${CURL_OPTS} --proxy http://${TARGET}:${PORT_FILTERED} http://www.myip.com/ | grep -qvi "access denied" >/dev/null
