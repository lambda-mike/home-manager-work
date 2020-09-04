{ pkgs, lib, ... }:

{
  config = ./polybar.config;
  enable = true;
  script = ''
    #! /usr/bin/env bash

    PATH=$PATH:${
      with pkgs;
      lib.makeBinPath [ coreutils gnugrep killall xorg.xrandr ]
    }

    # Terminate already running bar instances
    killall -eqw polybar

    # Launch polybar on primary monitor first
    mprim=$(xrandr --query | grep " connected" | grep "primary" cut -d" " -f1)
    MONITOR="$mprim" polybar --reload mainbar-xmonad &

    # Launch polybar on other monitors
    for m in $(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1); do
      MONITOR="$m" polybar --reload mainbar-xmonad &
    done

    echo "Polybar launched..."
'';
}
