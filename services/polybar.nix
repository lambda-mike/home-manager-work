theme:
{ config, lib, pkgs, ... }:

let
  polybarHead =
    builtins.replaceStrings
      [ "##MAIN_COLOUR##" "##FONT##" ]
      [ theme.colours.mainLight theme.font ]
      (builtins.readFile ./polybar_head.config);
  polybarConfig =
    polybarHead + (builtins.readFile ./polybar.config);
  polybarConfigPath = "${config.xdg.configHome}/polybar/config.ini";
in {
  services.polybar = {
    extraConfig = polybarConfig;
    enable = true;
    package = pkgs.polybar.override {
      pulseSupport = true;
    };
    script = ''
#! /usr/bin/env bash

isVertical() {
  local monitor="$1"
  local isPrimary="$(xrandr --query | grep "$monitor" | grep "primary")"
  if [[ -n "$isPrimary" ]]; then
    local resolutionIndex=4
  else
    local resolutionIndex=3
  fi
  local width=$(xrandr --query | grep "$monitor" | cut -d" " -f"$resolutionIndex" | cut -d"+" -f1 | cut -d"x" -f1)
  local height=$(xrandr --query | grep "$monitor" | cut -d" " -f"$resolutionIndex" | cut -d"+" -f1 | cut -d"x" -f2)
  local result
  [[ "$width" -lt "$height" ]] && return
}

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
if isVertical "$mprim"; then
  bar="shortbar-xmonad"
else
  bar="mainbar-xmonad"
fi
MONITOR="$mprim" polybar --reload --config=${polybarConfigPath} "$bar" 2>&1 | tee $log0 & disown

# Launch polybar on other monitors
for m in $(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1); do
  logm="/tmp/polybar_$m.log"
  echo "-----" | tee $logm
  if isVertical "$m"; then
    bar="shortbar-xmonad"
  else
    bar="mainbar-xmonad"
  fi
  MONITOR="$m" polybar --reload --config=${polybarConfigPath} "$bar" 2>&1 | tee $logm & disown
done

echo "Polybar launched..."
'';
  };
}
