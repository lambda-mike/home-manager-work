{
  config = ./polybar.config;
  enable = true;
  script = ''
    #! /usr/bin/env bash

    # Terminate already running bar instances
    killall -eqw polybar

    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      MONITOR="$m" polybar --reload mainbar-xmonad -c ~/.config/polybar/config &
    done
'';
}
