#!/usr/bin/env bash

readonly poweroffO="(S)hutdown"
readonly rebootO="(R)eboot"
readonly suspendO="(s)uspend"
readonly hibernateO="(H)ibernate"
readonly lockO="(l)ock"
readonly exitO="e(x)it"

readonly result="$(echo -e "$poweroffO\n$rebootO\n$suspendO\n$hibernateO\n$lockO\n$exitO" | rofi -dmenu)"

case "$result" in
    "$lockO")
        ~/.config/leftwm/themes/current/lock.sh
        ;;
    "$poweroffO")
        systemctl poweroff
        ;;
    "$rebootO")
        systemctl reboot
        ;;
    "$suspendO")
        systemctl suspend && ~/.config/leftwm/themes/current/lock.sh
        ;;
    "$hibernateO")
        systemctl hibernate && ~/.config/leftwm/themes/current/lock.sh
        ;;
    "$exitO")
        loginctl terminate-session ${XDG_SESSION_ID-}
        ;;
esac
