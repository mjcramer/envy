#!/bin/bash

script_dir=$(cd $(dirname $0); pwd -P)

while getopts ":i:p:u:" opt; do 
  case ${opt} in
    i)
      ip=$OPTARG
	    ;;
    p)
      ports=$OPTARG
      ;;
    u)
      user=$OPTARG
      ;;
    \?)
      echo "Invalid option: -${opt}" >&2
      exit 1
      ;;
    :)
      echo "Option -${opt} requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $(($OPTIND - 1))

case $(uname -s) in
	Darwin)
    lsof -Pn -i4TCP -sTCP:LISTEN | while read -r command pid other; do
      printf '%s\t%s\t%s\n' "$command" "$pid"
    done
		;;
esac

# for proc in ${listening_procs}; do
# echo $proc
# done
