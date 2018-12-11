#!/usr/bin/env bash
contains () { for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done; return 1; }
