#!/bin/bash

export TIMEOUT=15
CONPREFIX=dansguardian_autotest

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

docker-compose -p ${CONPREFIX} -f test.yml build || exit 1
docker-compose -p ${CONPREFIX} -f test.yml up -d || exit 1

OUTPUT=$(mktemp ${TMPDIR:-/tmp/}testoutXXXXXXXXXX)
RESULT=0
for TEST in $(find tests -maxdepth 1 -type f); do
	echo -n "${TEST} ... "
	THISRESULT=0
	bash ${TEST} >${OUTPUT} 2>&1 || THISRESULT=$?
        if [ $THISRESULT -eq 0 ]; then
		echo PASS
	else
		RESULT=$THISRESULT
		echo FAIL
		cat ${OUTPUT}
	fi
done
rm ${OUTPUT}

docker-compose -p ${CONPREFIX} -f test.yml stop
docker-compose -p ${CONPREFIX} -f test.yml rm -f -v

if [ $RESULT -eq 0 ]; then
	echo "PASS"
else
	echo "FAIL"
fi

exit $RESULT

