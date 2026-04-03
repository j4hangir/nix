#!/usr/bin/env bash
if [ $# -eq 0 ]; then
  dir="."
else
  dir="$@"
fi
ls "$dir" | wc -l
