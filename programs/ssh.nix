{ config, lib, pkgs, ... }:

{
  programs = {
    ssh =
      {
        compression = true;
        enable = true;
        matchBlocks."mike.github.com" = {
          hostname = "github.com";
          identityFile = "~/.ssh/id_ed25519";
          user = "git";
        };
      };
  };
}
