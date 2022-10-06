#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

namespace=default
label=${USER}-toolbox
image=mjcramer/toolbox

usage() {
    echo "This script creates a toolbox shell running on the current kubernetes context"
    echo "Usage: ${0##*/} [flags] <parameter1> <parameter2> ..."
    echo "  -h            Print usage instructions"
    echo "  -n NAMESPACE  Run shell in the namespace"
    echo "  -l LABEL      Naming label to apply to pod, e.g. ${label}"
    echo "  -i IMAGE      Use IMAGE as toolbox image (default: ${image}"
}

while getopts ":hn:l:i:" opt; do
    case $opt in
    h)
        usage
        exit 0
        ;;
    n)
        namespace=$OPTARG
        ;;
    l)
        label=$OPTARG
        ;;
    i)
        image=$OPTARG
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

kubectl run -i --tty --rm --namespace ${namespace} ${label} --image=${image} --restart=Never -- $@

