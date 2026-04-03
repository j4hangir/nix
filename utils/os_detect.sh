#!/usr/bin/env bash
case $OSTYPE in
  darwin*)  echo mac ;;
  linux*)   echo linux ;;
  win*)     echo win ;;
  cygwin*|msys*) echo linux-win ;;
  freebsd*) echo freebsd ;;
esac
