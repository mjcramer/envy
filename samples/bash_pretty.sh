#!/usr/bin/env bash

color() {

	echo color
}

heading1() {
    char=${2:-=}
    echo -e "\033[1;33m"
    printf "${char}%.0s" $(seq -3 ${#1})
    echo
    echo -e "| $1 |"
    printf "${char}%.0s" $(seq -3 ${#1})
    echo -e "\033[0m"
    echo
}

heading2() {
    char=${2:-_}
    echo -e "\033[97;1m"
    echo -e "  $1  "
    printf " "
    printf "${char}%.0s" $(seq -1 ${#1})
    echo -e "\033[0m"
    echo
}


function main() {
	echo "Testing colors..."
	echo $@
}


(return 0 2>/dev/null) || main $@
