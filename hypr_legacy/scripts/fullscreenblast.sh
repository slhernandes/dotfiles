#!/bin/sh
hyprctl --batch "keyword animations:enabled 0; dispatch fullscreenstate 1"
grimblast save active $1
hyprctl --batch "dispatch fullscreenstate $2; keyword animations:enabled 1"
