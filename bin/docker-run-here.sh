#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

echo=
entrypoint=bash
docker_opts=

usage() {
    echo "This script runs a given docker image in interactive mode"
    echo "Usage: ${0##*/} [flags] <IMAGE> <ARGS>"
    echo "  -h             Print usage instructions"
    echo "  -c             Output command only"
    echo "  -n             Use host networking"
    echo "  -e ENTRYPOINT  The shell to run (default: ${entrypoint})"
}

while getopts ":hcne:" opt; do
    case $opt in
    h)
        usage
        exit 0
        ;;
    c)
        echo=echo
        ;;
    n)
        [[ -z $docker_opts ]] && docker_opts=="--network host" || docker_opts="$docker_opts --network host"
        ;;
    e)
        [[ -z $docker_opts ]] && docker_opts=="--entrypoint" || docker_opts="$docker_opts --entrypoint $OPTARG"
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
  --entrypoint ${entrypoint} \
  ${docker_opts} \
  $@
