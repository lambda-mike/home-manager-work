{ pkgs, config, ... }:

{
  xsession = {
    enable = true;
    initExtra = ''
    autorandr -c
    ${config.xdg.configHome}/fehbg &
  '';
  };
}
