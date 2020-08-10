#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

A=false
B=default

while getopts ":ab:" opt; do
    case $opt in
    a)
        A=true
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

if [ "${A}" == true ]; then
	echo "B is ${B}"
else 
	echo "A is not set"
fi


