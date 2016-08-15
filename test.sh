#!/bin/bash

source "$(dirname $0)/sh2ju.sh"

CONPREFIX=dansguardian_autotest
COMPOSE="docker-compose -p ${CONPREFIX} -f test.yml"

export TIMEOUT=15
export CURL_OPTS="--retry 3 --connect-timeout ${TIMEOUT} -#"

TARGET=
if [ -n "${DOCKER_HOST}" ]; then
	TARGET=$(echo $DOCKER_HOST | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
else
	TARGET=$(ifconfig docker0 | grep "inet addr" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)
fi

if [ -z "${TARGET}" ]; then
	echo "No docker0 or DOCKER_HOST"
	exit 1
fi

echo "Testing docker instance at ${TARGET}"
export TARGET

${COMPOSE} build || exit 1
${COMPOSE} up -d || exit 1

export PORT_FILTERED=$(${COMPOSE} port --protocol=tcp proxy 3128 2>/dev/null | cut -d : -f 2)
export PORT_CACHED=$(${COMPOSE} port --protocol=tcp proxy 8123 2>/dev/null | cut -d : -f 2)
export PORT_INTERCEPT=$(${COMPOSE} port --protocol=tcp proxy 8124 2>/dev/null | cut -d : -f 2)
export PORT_ACCESSDENIED=$(${COMPOSE} port --protocol=tcp proxy 8125 2>/dev/null | cut -d : -f 2)

sleep 3s

OUTPUT=$(mktemp -t testoutXXXXXXXXXX)
RESULT=0
for TEST in $(find tests -maxdepth 1 -type f); do
	echo -n "${TEST} ... "
	THISRESULT=0
        juLog ${TEST} >${OUTPUT} 2>&1 || THISRESULT=$?
        if [ $THISRESULT -eq 0 ]; then
		echo PASS
	else
		RESULT=$THISRESULT
		echo FAIL
		cat ${OUTPUT}
	fi
done
rm ${OUTPUT}

${COMPOSE} stop
${COMPOSE} rm -f -v

if [ $RESULT -eq 0 ]; then
	echo "PASS"
else
	echo "FAIL"
fi

exit $RESULT

