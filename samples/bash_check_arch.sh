#!/bin/bash

arch=$(uname -s)
case $arch in 
	Darwin)
		echo "Darwin!"
		;;
	Linux)
		echo "Linux!"
		;;
	*)
		echo "Unknown!"
		;;
esac


