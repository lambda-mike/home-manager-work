theme:
{ pkgs, ... }:

let xmonadTheme =
    builtins.replaceStrings
      [ "##MAIN_LIGHT##" "##MAIN_DARK##" "##FONT##" ]
      [ theme.colours.mainLight theme.colours.mainDark theme.font ]
      (builtins.readFile ./xmonad.theme.hs);
    xmonadConfig =
      (builtins.readFile ./xmonad.hs) + xmonadTheme;
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
