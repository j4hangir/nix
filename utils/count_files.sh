#!/usr/bin/env bash
if [ $# -eq 0 ]; then
  dir="."
else
  dir="$@"
fi
find "$dir" -type f | wc -l
