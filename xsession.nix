{ config, pkgs, wm ? "xmonad", ... }:
let
  choice = if sessions ? wm then wm else "xmonad";
  sessions = {
    xmonad = {
      xsession = {
        enable = true;
        initExtra = ''
        autorandr -c
          ${config.xdg.configHome}/fehbg &
        '';
     };
    };
    leftwm = {
      xsession = {
        enable = true;
        windowManager.command = ''
          ${pkgs.leftwm}/bin/leftwm &
          waitPID=$!
          test -n "$waitPID" && wait "$waitPID"
        '';
      };
    };
  };
in sessions.${choice}
