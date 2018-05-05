string=abcdef
# ${parameter:offset}
# ${parameter:offset:length}
echo ${string}             # abcdef
echo ${string:0:3}         # abc
echo ${string:1:3}         # bcd
echo ${string:2}           # cdef
echo ${string: -2}         # ef
echo ${#string}            # 6
echo "======"
FILEPATH=/root/dir/file.tar.gz
echo ${FILEPATH##*/}       # file.tar.gz
echo ${FILEPATH##*.}       # gz
echo ${FILEPATH#*.}        # tar.gz
echo ${FILEPATH%/*}        # /root/dir
echo ${FILEPATH%.*}        # /root/dir/file.tar
echo ${FILEPATH%%.*}       # /root/dir/file
echo ${FILEPATH/%.*/.zip}  # /root/dir/file.zip
echo "======"
# if VAR is null, then
echo "VAR1:-${VAR1:-default value; VAR1 remains empty} => $VAR1"
echo "VAR2:=${VAR2:=default value; assigned to VAR2} => $VAR2"
echo "VAR4:+${VAR4:+alternative value if VAR4 defined} => $VAR4"
VAR5="VAR5 remains the same"
echo "VAR5:+${VAR5:+alternative value if VAR5 defined} => $VAR5"
echo "VAR3:?${VAR3:?no such variable!}"
