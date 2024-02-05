#!/usr/bin/env bash

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

# Terminate already running bar instances
killall -eqw polybar

# Launch polybar on other monitors
primaryBar=""
monitors="$(polybar -m | grep -v primary | cat <(polybar -m | grep primary) -)"
echo "$monitors" | while read -r monitorLine
do
  monitor=$(echo $monitorLine | cut -d':' -f1)
  dimensions=$(echo "$monitorLine" | cut -d' ' -f2)
  index=$(leftwm state -q | jq --raw-output '.workspaces[] | select((.w | tostring) + "x" + (.h | tostring) + "+" + (.x | tostring)+ "+" + (.y | tostring) == "'"$dimensions"'") | .index')
  logm="/tmp/polybar_${monitor}.log"
  echo "-----" | tee $logm
  echo "$monitor" | tee $logm
  echo "$dimensions" | tee $logm
  echo "$index" | tee $logm
  if isVertical "$monitor"; then
    bar="shortbar$index"
  else
    bar="mainbar$index"
  fi
  MONITOR="$monitor" polybar --reload --config="$SCRIPTPATH/polybar.config" "$bar" 2>&1 | tee $logm &
  if [[ -z "$primaryBar" ]]; then primaryBar="$(pidof polybar)"; fi
done

$(spleep 3 && polybar-msg -p "$primaryBar" cmd restart) &
echo "Polybar launched..."
