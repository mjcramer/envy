#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

A=false
PORT=8080

usage() {
    echo "This script find namespaces in the 'Terminating' state and delete them." 
    echo "Usage: ${0##*/} [flags] <parameter1> <parameter2> ..."
    echo "  -h          Print usage instructions"
    echo "  -a          Option A switch"
    echo "  -p PORT     Port number for kubernetes control plane"
}

while getopts ":hab:" opt; do
    case $opt in
    h)
        usage
        exit 0
        ;;
    a)
        A=true
        ;;
    p)
        PORT=$OPTARG
        ;;
    \?)
        echo "Invalid option: -$opt" >&2
        exit 1
        ;;
    :)
        echo "Option -$opt requires an argument." >&2
        exit 1
        ;;
    esac
done
shift $(($OPTIND - 1))

if [ "${A}" == true ]; then
	echo "B is ${B}"
else 
	echo "A is not set"
fi

for ns in $(kubectl get ns -o jsonpath='{.items[?(@.status.phase=="Terminating")].metadata.name}'); do
    printf "Cleaning up $ns namespace ...\n"
    kubectl get ns $ns -o json > /var/tmp/$ns.json
    sed -i '.bk' '/finalizers/{N;s/\n.*//;}' /var/tmp/$ns.json
    curl --silent --show-error -X PUT \
      --data @/var/tmp/$ns.json http://localhost:$PORT/api/v1/namespaces/$ns/finalize \
      --header "Content-Type: application/json" \
      --output /dev/null
    rm /var/tmp/$ns-ns.json$$ /var/tmp/$ns-ns.json$$.bk
done

