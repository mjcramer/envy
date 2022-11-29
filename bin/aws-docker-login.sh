#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd -P)

A=false
region=us-east-2
account=263734463344

usage() {
    echo "This script does wonderful things!"
    echo "Usage: ${0##*/} [flags] <parameter1> <parameter2> ..."
    echo "  -h             Print usage instructions"
    echo "  -a ACCOUNT_ID  AWS account ID where ECR is located (default: ${account})"
    echo "  -r REGION      AWS region where ECR is located (default: ${region})"
}

while getopts ":ha:r:" opt; do
    case $opt in
    h)
        usage
        exit 0
        ;;
    a)
        account=$OPTARG
        ;;
    r)
        region=$OPTARG
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

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account}.dkr.ecr.${region}.amazonaws.com

