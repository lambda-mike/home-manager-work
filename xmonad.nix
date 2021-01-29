{ pkgs, config, ... }:

{
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    # TODO build xmonad from parts based on arguments
    config = pkgs.writeText "xmonad.hs" (builtins.readFile ./xmonad.hs);
    extraPackages = haskellPackages : [
      haskellPackages.dbus
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      haskellPackages.xmonad
    ];
  };
}
