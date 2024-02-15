#!/usr/bin/env bash

cat ${XDG_CONFIG_HOME}/leftwm/config.ron |
   grep command | tr -d '()' |
   rofi -dmenu -i -theme-str '#window { fullscreen: true; }'
