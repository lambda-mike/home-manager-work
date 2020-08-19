{ pkgs, ... }:
{
  enable = true;
  enableContribAndExtras = true;
  config = pkgs.writeText "xmonad.hs" (builtins.readFile ./xmonad.hs);
  extraPackages = haskellPackages : [
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad
  ];
}
