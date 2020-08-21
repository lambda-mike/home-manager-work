{ pkgs, ... }:

{
  enable = true;
  initExtra = "autorandr -c";
  pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
  windowManager.xmonad = import ./xmonad.nix { inherit pkgs; };
}
