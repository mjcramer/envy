#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

echo=
shell=bash
docker_opts=

usage() {
    echo "This script runs a given docker image in interactive mode"
    echo "Usage: ${0##*/} [flags] <IMAGE> <ARGS>"
    echo "  -h          Print usage instructions"
    echo "  -o          Output command only"
    echo "  -n          Use host networking"
    echo "  -s SHELL    The shell to run (default: ${shell})"
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
    n)
        docker_opts="--network host"
        ;;
    s)
        shell=$OPTARG
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
  --volume $(pwd -P):/home/$(basename $(pwd -P)) \
  --entrypoint ${shell} \
  ${docker_opts} \
  $@

