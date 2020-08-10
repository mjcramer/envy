#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
script_file=$(basename "${BASH_SOURCE[0]}")

help() {
	echo ${this_file} 
	cat <<-'EOF'
$0
“a” and “option-a” have optional arguments with default values.
“b” and “flag-b” have no arguments, acting as sort of a flag.
“c” and “required-c” have required arguments.
EOF
}

echo "Running $script_file script in directory $script_dir."
OPTS=`getopt -o a::bc: --long option-a:,:flag-b,required-c: -n "$0" -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; help ; exit 1 ; fi
echo "$OPTS"
eval set -- "$OPTS"

A="initial value"
B="is not set"

# Extract options and their arguments into variables.
while true ; do
    echo "Processing argument $1"
    case "$1" in
        -a | --option-a)
            case "$2" in
                "") 
                    A='some default value' 
                    ;;
                *) 
                    A=$2 
                    ;;
            esac
            shift 2 ;;
        -b | --flag-b) 
            B="is set" 
            shift ;;
        -c | --required-c)
            case "$2" in
                "") 
                    shift 2 ;;
                *) 
                    C=$2
                    shift 2 ;;
            esac 
            ;;
        --) 
            shift ; break ;;
        *) 
            echo "Internal error!" 
            exit 1 ;;
    esac
done

# do something with the variables -- in this case the lamest possible one :-)
echo "A = $A"
echo "B = $B"
echo "C = $C"
