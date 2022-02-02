#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

echo=
B=default

usage() {
    echo "This script does wonderful things!"
    echo "Usage: ${0##*/} [flags] <parameter1> <parameter2> ..."
    echo "  -h          Print usage instructions"
    echo "  -a          Option A switch"
    echo "  -b OPTARG   Option B with parameter"
}

while getopts ":hob:" opt; do
    case $opt in
    h)
        usage
        exit 0
        ;;
    o)
        echo=echo
        ;;
    b)
        B=$OPTARG
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


$echo docker run --rm -it \
  --volume $(pwd -P):/home/$(basename $(dirname $(pwd -P))) \
  --entrypoint bash \
  $@

