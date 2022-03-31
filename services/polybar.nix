theme:
{ pkgs, lib, ... }:

let
  polybarHead =
    if theme == "blue" then
      ./polybar_head_blue.config
    else if theme == "green" then
      ./polybar_head_green.config
    else
      ./polybar_head_blue.config;
  polybarConfig =
    (builtins.readFile polybarHead) + (builtins.readFile ./polybar.config);
in {
  services.polybar = {
    extraConfig = polybarConfig;
    enable = true;
    package = pkgs.polybar.override {
      pulseSupport = true;
    };
    script = ''
#! /usr/bin/env bash

PATH=$PATH:${
                   with pkgs;
                   lib.makeBinPath [ coreutils gnugrep killall xorg.xrandr ]
                 }

# Terminate already running bar instances
killall -eqw polybar

# Launch polybar on primary monitor first
mprim=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
log0="/tmp/polybar_$mprim.log"
echo "-----" | tee $log0
MONITOR="$mprim" polybar --reload mainbar-xmonad 2>&1 | tee $log0 & disown

# Launch polybar on other monitors
for m in $(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1); do
  logm="/tmp/polybar_$m.log"
  echo "-----" | tee $logm
  MONITOR="$m" polybar --reload mainbar-xmonad 2>&1 | tee $logm & disown
done

echo "Polybar launched..."
'';
  };
}
