theme:
{ pkgs, ... }:

let xmonadTheme =
      if theme == "blue" then
        ./xmonad.blue.hs
      else
        # TODO add green theme
        ./xmonad.blue.hs;
    xmonadConfig =
      (builtins.readFile ./xmonad.hs) + (builtins.readFile xmonadTheme);
in {
  xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = pkgs.writeText "xmonad.hs" xmonadConfig;
    extraPackages = haskellPackages : [
      haskellPackages.dbus
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      haskellPackages.xmonad
    ];
  };
}
