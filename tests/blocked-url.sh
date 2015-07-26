curl ${CURL_OPTS} --proxy http://${TARGET}:${PORT_FILTERED} http://zdnet.com/adverts | grep -qi "access denied"
