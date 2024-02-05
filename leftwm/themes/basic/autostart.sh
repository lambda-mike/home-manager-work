#!/usr/bin/env bash

if [[ -z "$(pidof brave)" ]]; then
  brave &
fi

if [[ -z "$(pidof emacs)" ]]; then
  emacs &
fi

if [[ -z "$(pidof alacritty)" ]]; then
  alacritty -t tmux -e tmux &
fi

workspacesNum="$(leftwm state -q | jq --raw-output '.workspaces | length')"

case "$workspacesNum" in
  "1")
    leftwm command "SendWorkspaceToTag 0 0"
    ;;
  "2")
    leftwm command "SendWorkspaceToTag 0 0"
    leftwm command "SendWorkspaceToTag 1 4"
    ;;
  *)
    leftwm command "SendWorkspaceToTag 0 0"
    leftwm command "SendWorkspaceToTag 1 4"
    leftwm command "SendWorkspaceToTag 2 3"
    ;;
esac