#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

A=false
namespace=default
label=$USER
image=mjcramer/toolbox

usage() {
    echo "This script creates a toolbox shell running on the current kubernetes context"
    echo "Usage: ${0##*/} [flags] <parameter1> <parameter2> ..."
    echo "  -h            Print usage instructions"
    echo "  -a            Option A switch"
    echo "  -n NAMESPACE  Run shell in the namespace"
    echo "  -l LABEL      Naming label to apply to pod, e.g. LABEL-toolbox"
    echo "  -i IMAGE      Use IMAGE as toolbox image (default: ${image}"
}

while getopts ":han:l:i:" opt; do
    case $opt in
    h)
        usage
        exit 0
        ;;
    a)
        A=true
        ;;
    n)
        namespace=$OPTARG
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

kubectl run -i --tty --rm --namespace ${namespace} ${label}-toolbox --image=mjcramer/toolbox --restart=Never
