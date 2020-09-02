{ pkgs, config, ... }:

{
  enable = true;
  initExtra = ''
    autorandr -c
    ${config.xdg.configHome}/fehbg &
    ${pkgs.haskellPackages.greenclip}/bin/greenclip daemon &
  '';
  pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
  windowManager.xmonad = import ./xmonad.nix { inherit pkgs; };
}
