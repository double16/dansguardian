curl ${CURL_OPTS} "http://${TARGET}:${PORT_ACCESSDENIED}/cgi-bin/dansguardian.pl?" | grep -qi "access denied"  >/dev/null
