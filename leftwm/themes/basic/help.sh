#!/usr/bin/env bash

cat ~/.config/leftwm/config.ron |
   grep command | tr -d '()' |
   rofi -dmenu -theme-str '#window { fullscreen: true; }'