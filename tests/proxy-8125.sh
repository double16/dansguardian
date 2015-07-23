curl -# "http://${TARGET}:8125/cgi-bin/dansguardian.pl?" | grep -qi "access denied"  >/dev/null
