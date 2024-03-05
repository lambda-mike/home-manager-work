{ windowManager }:
{ config, pkgs, ... }:
let
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
in sessions.${windowManager}
