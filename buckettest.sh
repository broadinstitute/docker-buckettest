#!/bin/bash

PROG=`basename $0`

usage() {
    echo "Usage: ${PROG} [-h] -b <web bucket> -t <test host> -u <url path>"
}

while getopts "b:ht:u:" flag; do
    case "$flag" in
    b)
        BUCKET=$OPTARG
        ;;
    h)
        usage
        exit 0
        ;;
    t)
        TESTHOST=$OPTARG
        ;;
    u)
        URLPATH=$OPTARG
        ;;
    \?)
        echo "Invalid option: -${OPTARG}"
        exit 1
        ;;
    :)
        echo "Option -${OPTARG} requires an argument."
        exit 2
        ;;
    esac
done

if [ -z "${BUCKET}" ]; then
    usage
    echo "Bucket name was not provided"
    exit 1
fi

if [ -z "${TESTHOST}" ]; then
    usage
    echo "Test host was not provided"
    exit 2
fi

if [ -z "${URLPATH}" ]; then
    usage
    echo "URL path was not provided"
    exit 3
fi

TESTIP=$( drill ${TESTHOST}.broadinstitute.org | grep "^${TESTHOST}" | awk '{print $5}' )
if [ -z "${TESTIP}" ]; then
    echo "Cannot resolve IP address for ${TESTHOST}"
    exit 4
fi

BUCKETHOST="${BUCKET}.broadinstitute.org"
HTTPURLS=( "http://${BUCKETHOST}${URLPATH}" "https://${BUCKETHOST}${URLPATH}" )

for u in "${HTTPURLS[@]}"; do
    echo
    echo "Testing ${u}"
    echo
    curl -kv \
        --resolve "${BUCKETHOST}:80:${TESTIP}" \
        --resolve "${BUCKETHOST}:443:${TESTIP}" \
        -o /dev/null \
        --url $u
done
