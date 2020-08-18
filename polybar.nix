{
  config = ./polybar.config;
  enable = true;
  script = ''
    #! /usr/bin/env bash
    set -eu

    # Terminate already running bar instances
    killall -eq polybar

    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      MONITOR="$m" polybar --reload mainbar-xmonad -c ~/.config/polybar/config &
    done
'';
}
