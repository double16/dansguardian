curl -# --proxy http://${TARGET}:3128 http://www.google.com/ | grep -qi "Google Search" >/dev/null
