#!/bin/bash

script_dir=$(cd $(dirname $0); pwd -P)

while getopts ":ab:" opt; do
    case $opt in
    a)
        exec=echo
		;;
    b)
        value=$OPTARG
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

echo "whoa..."
