{ config, lib, pkgs, ... }:

{
  services = {
    screen-locker = {
      enable = true;
      inactiveInterval = 45;
      lockCmd = "${config.xdg.configHome}/lock-screen";
    };
  };
}
