{ pkgs, ... }:
{
  enable = true;
  enableContribAndExtras = true;
  config = pkgs.writeText "xmonad.hs" ''
  import XMonad
  main = xmonad def
      { terminal    = "alacritty"
      , modMask     = mod4Mask
      , borderWidth = 2
      , normalBorderColor  = "#cccccc"
      , focusedBorderColor = "#00558c"
      }
'' ;
  extraPackages = haskellPackages : [
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad
  ];
}
