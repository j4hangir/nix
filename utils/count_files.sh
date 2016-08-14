#!/usr/bin/env bash
#find "$@" -printf ' ' | wc -c
if [ $# -eq 0 ]
  then dir="."
else
  dir="$@"
fi
echo $(expr `find "$dir" -type f | wc -l`)
