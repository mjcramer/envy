#!/bin/bash

BOM_DIR=/private/var/db/receipts

if [ -z "$@" ]; then
	echo "Please provide a list of file names."
	exit 1
fi

for bom_file in $(ls $BOM_DIR/*.bom); do
	for file in $@; do
		if [ -n "$(lsbom -fls $bom_file | grep -H $file)" ]; then
			echo "$file is owned by $bom_file."
		fi
	done
done


#for bom_file in $(find $BOM_DIR $!)!)


