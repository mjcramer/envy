#!/bin/bash

if [ -z "$1" ]; then
	echo -n "Please enter the tag you'd like to delete: "
	read tag
else
	tag=$1
fi

git tag -d $tag
git push origin :refs/tags/$tag
