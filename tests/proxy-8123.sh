curl -# --proxy http://${TARGET}:8123 http://www.google.com/ | grep -qi "Google Search" >/dev/null
