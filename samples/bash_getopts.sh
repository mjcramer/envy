#!/bin/bash

# “a” and “option-a” have optional arguments with default values.
# “b” and “flab-b” have no arguments, acting as sort of a flag.
# “c” and “required-c” have required arguments.

# set an initial value for the flag
B=0

# read the options
TEMP=`getopt -o a::bc: --long option-a::,flab-b,required-c: -n "$0" -- "$@"`
echo $TEMP
eval set -- "$TEMP"

echo $TEMP
# extract options and their arguments into variables.
while true ; do
	echo "processing $1"
    case "$1" in
        -a|--option-a)
            case "$2" in
                "") A='some default value' ;;
                *) A=$2 ;;
            esac 
			shift 2 ;;
        -b|--flab-b) B=1 ; shift ;;
        -c|--required-c)
            case "$2" in
                "") shift 2 ;;
                *) C=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# do something with the variables -- in this case the lamest possible one :-)
echo "A = $A"
echo "B = $B"
echo "C = $C"

