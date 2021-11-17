#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

A=false
bootstrap_servers="localhost:9092"

usage() {
    echo "This script dumps everything from a kafka topic."
    echo "Usage: ${0##*/} [flags] <parameter1> <parameter2> ..."
    echo "  -h          Print usage instructions"
    echo "  -a          Option A switch"
    echo "  -b SERVERS  Bootstrap servers to kafka command"
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
    b)
        bootstrap_servers=$OPTARG
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

if [ -z "$1" ]; then
  echo "Please specify a topic to dump."
  exit 1
else
  topic=$1
fi

kcat -b ${bootstrap_servers} -C -t ${topic} -o beginning -D "" -e | protoc --decode_raw

