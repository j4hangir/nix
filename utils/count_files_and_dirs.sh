#!/usr/bin/env bash
#find "$@" -printf ' ' | wc -c
if [ $# -eq 0 ]
  then dir="."
else
  dir="$@"
fi
ret=$(find "$dir" | wc -l)
# exclude .
echo `expr $ret - 1`

