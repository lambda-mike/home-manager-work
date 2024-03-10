#!/usr/bin/env bash

readonly poweroffO="(S)_utdown"
readonly rebootO="(r)eboot"
readonly suspendO="(s)uspend"
readonly hibernateO="(h)ibe_nate"
readonly lockO="(l)ock"
readonly exitO="e(x)it"

readonly result="$(echo -e "$poweroffO\n$rebootO\n$suspendO\n$hibernateO\n$lockO\n$exitO" | rofi -dmenu -l 6)"

case "$result" in
    "$lockO")
        ${XDG_CONFIG_HOME}/lock-screen
        ;;
    "$poweroffO")
        systemctl poweroff
        ;;
    "$rebootO")
        systemctl reboot
        ;;
    "$suspendO")
        systemctl suspend && ${XDG_CONFIG_HOME}/lock-screen
        ;;
    "$hibernateO")
        systemctl hibernate && ${XDG_CONFIG_HOME}/lock-screen
        ;;
    "$exitO")
        loginctl terminate-session ${XDG_SESSION_ID-}
        ;;
esac
