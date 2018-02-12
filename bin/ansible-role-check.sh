#!/bin/bash

if [ -n "$1" ]; then
    prefix=${1/%\//}
    for file in $(find $prefix -type f); do
        first_line=$(head -n 1 $file | sed 's:^# \(.*\):\1:')
        trunc=$(echo $file | sed "s:^$prefix/\(.*\):\1:")
        echo $trunc
        if [ "${ftrunc}" != "$first_line" ]; then
            echo "$file <--> $first_line"
        fi
    done
else
    echo "Enter a directory to scan"
    exit 1
fi
