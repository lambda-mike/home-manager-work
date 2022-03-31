theme:
{ pkgs, ... }:

# TODO pass font and replace in theme file
let xmonadTheme =
      if theme == "blue" then
        ./xmonad.blue.hs
      else if theme == "green" then
        ./xmonad.green.hs
      else
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
