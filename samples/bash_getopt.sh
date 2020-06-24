#!/bin/bash
#
# Example of how to parse short/long options with 'getopt'
#

OPTS=`getopt -o vhns: --long verbose,dry-run,help,stack-size: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

VERBOSE=false
HELP=false
DRY_RUN=false
STACK_SIZE=0

while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -h | --help )    HELP=true; shift ;;
    -n | --dry-run ) DRY_RUN=true; shift ;;
    -s | --stack-size ) STACK_SIZE="$2"; shift; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

echo VERBOSE=$VERBOSE
echo HELP=$HELP
echo DRY_RUN=$DRY_RUN
echo STACK_SIZE=$STACK_SIZE

exit






#!/usr/bin/env bash

help() {
	echo bar
	cat <<-'EOF'
$0
“a” and “option-a” have optional arguments with default values.
“b” and “flab-b” have no arguments, acting as sort of a flag.
“c” and “required-c” have required arguments.
EOF
}

# Set an initial value for the flag
B=0

#OPTS=`getopt -o vhns: --long verbose,dry-run,help,stack-size: -n 'parse-options' -- "$@"`
OPTS=`getopt -o a::bc: --long option-a:,:flag-b,required-c: -n "$0" -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

A=1
B=0

while true; do
	echo $1
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -h | --help )
		help; shift ;;
    -n | --dry-run ) DRY_RUN=true; shift ;;
    -s | --stack-size ) STACK_SIZE="$2"; shift; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

exit

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

