#!/bin/bash

# Generates an 8 bit color table (256 colors), using ANSI escape codes. 
# e.g.
#   \033[48;5;${val}m
#   ANSI CSI+SGR (see "ANSI Code" on Wikipedia)

echo -en "\n   +  "
#for i in {0..0}; do
  for j in {0..15}; do
    printf "%2b " $j
  done
#done

printf "\n\n"
for i in {0..15}; do
  let "val = i * 16"
  printf " %3b  " ${val}
  for j in {0..15}; do
    let "val = i * 16 + j"
    echo -en "\033[48;5;${val}m  \033[m "
  done
  printf "\n"
done

