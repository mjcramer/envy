#!/bin/bash

script_dir=$(cd $(dirname $0); pwd -P)

if [ -n "$IPMI_HOST" ]; then
	host=$IPMI_HOST
fi
if [ -n "$IPMI_USER" ]; then
	user=$IPMI_USER
fi
if [ -n "$IPMI_PASSWORD" ]; then
	password=$IPMI_PASSWORD
fi

while getopts ":h:p:u:" opt; do 
  case $opt in
    h)
      host=$OPTARG
	    ;;
    p)
      password=$OPTARG
      ;;
    u)
      user=$OPTARG
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

command="ipmitool -I lanplus -H $host -U $user -P $password $@"
echo "Executing '$command'..."
$command