#!/bin/sh

# basic
if test -e ~; then
  echo 'test -e ~'
fi

# alias
if [ -e ~ ]; then
  echo '[ -e ~ ]'
fi

# bash/zsh extention; not POSIX
if [[ -e ~ ]]; then
  echo '[[ -e ~ ]]'
fi

# shortcut with exit status
test -e ~ && echo 'test -e ~ && echo' || echo 'not printed'
[ -e ~ ] && echo '[ -e ~ ] && echo' || echo 'not printed'
[[ -e ~ ]] && echo '[[ -e ~ ]] && echo' || echo 'not printed'
[[ ! -e ~ ]] && echo 'not printed' || echo '[[ ! -e ~ ]] || echo'

# AND/OR
[ -e ~ ] && [ -d ~ ] && echo '[ -e ~ ] && [ -d ~ ]'
[ -e ~ ] || [ -f ~ ] && echo '[ -e ~ ] || [ -f ~ ]'
[[ -e ~ && -d ~ ]] && echo '[[ -e ~ && -d ~ ]]'
[[ -e ~ || -f ~ ]] && echo '[[ -e ~ || -f ~ ]]'

# string; variables should be "$quoted"
EMPTY=''
NOTEMPTY='CONTENT'
[ -z "$EMPTY" ] && echo '-z "$EMPTY"'
[ -n "$NOTEMPTY" ] && echo '-n "$NOTEMPTY"'
[ "$NOTEMPTY" != "$EMPTY" ] && echo '"$NOTEMPTY" != "$EMPTY"'
[ "$NOTEMPTY" = "CONTENT" ] && echo '"$NOTEMPTY" = "CONTENT"'

# file and directory
[ -e ~ ] && echo '-e ~'
[ -d ~ ] && echo '-d ~'
[ -f ~/.bashrc ] && echo '-f ~/.bashrc'
[ -L ~/.bashrc ] && echo '-L ~/.bashrc'
[ -r ~/.bashrc ] && echo '-r ~/.bashrc'
[ -w ~/.bashrc ] && echo '-w ~/.bashrc'
[ -x /bin/sh ] && echo '-x /bin/sh'

# numeric
one=1
two=2
[ $one -eq 1 ] && echo '$one -eq 1'
[ $one -ne $two ] && echo '$one -ne $two'
[ $one -lt $two ] && echo '$one -lt $two'
[ $one -le $two ] && echo '$one -le $two'
[ $two -gt $one ] && echo '$two -gt $one'
[ $two -ge $one ] && echo '$two -ge $one'
