#!/bin/bash
#
# This file echoes a bunch of color codes to the terminal to demonstrate
# what's available. Each line is the color code of one forground color,
# out of 17 (default + 16 escapes), followed by a test use of that color
# on all nine background colors (default + 8 escapes).
#
fg_colors=$(seq 30 37)
bg_colors=$(seq 40 47)
style_codes=$(seq 0 4)

printf "\n             "
for bg_color in $bg_colors; do 
  printf "   %2s   " $bg_color
done 
printf "\n      ---------------"
for bg_color in $bg_colors; do 
  echo -n "-------"
done 
printf "\n"

printf "      | "
for style_code in $style_codes; do
  echo -en "\033[${style_code}m${style_code}\033[0m"
done
printf " "
for bg_color in $bg_colors; do 
  # printf " "
  echo -en "\033[${bg_color}m \033[0m"
  for style_code in $style_codes; do
    echo -en "\033[${style_code};${bg_color}m${style_code}\033[0m"
  done
  echo -en "\033[${bg_color}m \033[0m"
  printf " "
done
printf "\n"
for fg_color in $fg_colors; do 
  printf "  %2s  |" ${fg_color}
  echo -en "\033[${fg_color}m \033[0m"
  for style_code in $style_codes; do
    echo -en "\033[${style_code};${fg_color}m${style_code}\033[0m"
  done
  echo -en "\033[${fg_color}m \033[0m"
  # printf " "
  for bg_color in $bg_colors; do 
    # printf " "
    echo -en "\033[${fg_color};${bg_color}m \033[0m"
    for style_code in $style_codes; do
      echo -en "\033[${style_code};${fg_color};${bg_color}m${style_code}\033[0m"
    done
    echo -en "\033[${fg_color};${bg_color}m \033[0m"
    printf " "
  done
  printf "\n"
done
printf "\n"
