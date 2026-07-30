#!/usr/bin/env dash

pass $@ | {
  IFS= read -r pass
  printf %s "$pass"
} | xargs copyq copy x-kde-passwordManagerHint secret text/plain
