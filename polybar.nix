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

    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      MONITOR="$m" polybar --reload mainbar-xmonad &
    done

    echo "Polybar launched..."
'';
}
