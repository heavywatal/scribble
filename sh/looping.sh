#!/bin/sh
for x in 1 2 3; do
  echo "$x"
done
# 1
# 2
# 3

for x in "1 2 3"; do
  echo "$x"
done
# 1 2 3

VARIABLE="1 2 3"
for x in $VARIABLE; do
  echo "$x"
done
# zsh in "1 2 3"
# bash in 1 2 3
# dash in 1 2 3
