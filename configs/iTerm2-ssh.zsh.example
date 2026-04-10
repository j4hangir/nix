if [[ -n "$ITERM_SESSION_ID" ]]; then
  trap "tab-reset" INT EXIT
  if [[ "$*" =~ "server1" ]]; then
    tab-color 255 0 0
  else
    tab-color 0 255 0
  fi
fi
