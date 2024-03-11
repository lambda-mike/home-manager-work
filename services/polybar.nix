{ theme, windowManager }:
{ config, lib, pkgs, ... }:
let
  polybarHead =
    builtins.replaceStrings
      [ "##MAIN_COLOUR##" "##FONT##" ]
      [ theme.colours.mainLight theme.font ]
      (builtins.readFile ./polybar_head.config);
  polybarLiquidStr =
    builtins.replaceStrings
      [ "##MAIN_COLOUR##" ]
      [ theme.colours.mainLight ]
      (builtins.readFile ../leftwm/themes/basic/polybar_template.liquid);
  polybarLiquid = pkgs.writeText "polybar.liquid" polybarLiquidStr;
  polybarConfig = polybarHead +
    (if windowManager == "xmonad"
    then builtins.readFile ./polybar_xmonad.config
    else builtins.replaceStrings
          [ "##POLYBAR_LIQUID_PATH##" ]
          [ "${polybarLiquid}" ]
          (builtins.readFile ./polybar_leftwm.config));
  polybarConfigPath = "${config.xdg.configHome}/polybar/config.ini";
  polybarScriptHead = ''
#!/usr/bin/env bash

isVertical() {
  local monitor="$1"
  local isPrimary="$(xrandr --query | grep -w "$monitor" | grep "primary")"
  if [[ -n "$isPrimary" ]]; then
    local resolutionIndex=4
  else
    local resolutionIndex=3
  fi
  local width=$(xrandr --query | grep -w "$monitor" | cut -d" " -f"$resolutionIndex" | cut -d"+" -f1 | cut -d"x" -f1)
  local height=$(xrandr --query | grep -w "$monitor" | cut -d" " -f"$resolutionIndex" | cut -d"+" -f1 | cut -d"x" -f2)
  local result
  [[ "$width" -lt "$height" ]] && return
}

PATH=$PATH:${
                   with pkgs;
                   lib.makeBinPath [ coreutils coreutils-full gnugrep jq killall leftwm procps xorg.xrandr which ]
                 }

# Terminate already running bar instances
killall -eqw polybar
  '';
  polybarXmonadScript = polybarScriptHead + ''

# Launch polybar on primary monitor first
mprim=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
log0="/tmp/polybar_$mprim.log"
echo "-----" | tee $log0
if isVertical "$mprim"; then
  bar="shortbar-xmonad"
else
  bar="mainbar-xmonad"
fi
MONITOR="$mprim" polybar --reload --config=${polybarConfigPath} "$bar" 2>&1 | tee -a $log0 & disown

# Launch polybar on other monitors
for m in $(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1); do
  logm="/tmp/polybar_$m.log"
  echo "-----" |& tee $logm
  if isVertical "$m"; then
    bar="shortbar-xmonad"
  else
    bar="mainbar-xmonad"
  fi
  MONITOR="$m" polybar --reload --config=${polybarConfigPath} "$bar" 2>&1 | tee -a $logm & disown
done

echo "Polybar launched..."
'';
  polybarLeftwmScript = polybarScriptHead + ''

monitors="$(polybar -m | grep -v primary | cat <(polybar -m | grep primary) -)"
echo "$monitors" | while read -r monitorLine
do
  monitor=$(echo $monitorLine | cut -d':' -f1)
  dimensions=$(echo "$monitorLine" | cut -d' ' -f2)
  index=$(leftwm state -q | jq --raw-output '.workspaces[] | select((.w | tostring) + "x" + (.h | tostring) + "+" + (.x | tostring) + "+" + (.y | tostring) == "'"$dimensions"'") | .index')
  logm="/tmp/polybar_$monitor.log"
  echo "-----" |& tee $logm
  echo "$monitor" |& tee -a $logm
  echo "$dimensions" |& tee -a $logm
  echo "$index" |& tee -a $logm
  if isVertical "$monitor"; then
    bar="shortbar$index"
  else
    bar="mainbar$index"
  fi
  MONITOR="$monitor" polybar --reload --config="${polybarConfigPath}" "$bar" 2>&1 | tee -a $logm &
done

sleep 3 && polybar-msg cmd restart >/dev/null && echo "Polybars restarted" &

echo "Polybar launched..."
  '';
in {
  services.polybar = {
    extraConfig = polybarConfig;
    enable = true;
    package = pkgs.polybar.override {
      pulseSupport = true;
    };
    script = (if windowManager == "xmonad" then polybarXmonadScript else polybarLeftwmScript);
  };
}
