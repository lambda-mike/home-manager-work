{ pkgs, config, ... }:

{
  xsession = {
    enable = true;
    initExtra = ''
    autorandr -c
    ${config.xdg.configHome}/fehbg &
  '';
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      size = 24;
    };
  };
}
