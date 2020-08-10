#!/usr/bin/env bash

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
	echo "This script can only be sourced, not executed. Please type 'source $BASH_SOURCE[0]...'"
	exit 1
fi

echo "Nice sourcing!"
