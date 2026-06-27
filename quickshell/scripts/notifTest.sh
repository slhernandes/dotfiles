#!/bin/bash

for i in $(seq 1 10); do
  notify-send "hello" "$i" -t 1000
done
