#!/bin/bash
array=(a b c d e f)   # bash        | zsh
echo ${array}         # a           | a b c d e f
echo ${array[0]}      # a           |
echo ${array[1]}      # b           | a
echo ${array[-1]}     # (error)     | f
echo ${array[@]}      # a b c d e f | a b c d e f
echo ${#array}        # 1           | 6
echo ${#array[@]}     # 6           | 6
echo "======"
echo ${array[@]:0:3}  # a b c
echo ${array[@]:1:3}  # b c d
echo ${array[@]:2}    # c d e f
echo ${array[@]: -2}  # e f
echo "======"
for x in "${array[*]:3}"; do
  echo "$x"
done                  # d e f
for x in "${array[@]:3}"; do
  echo "$x"
done
