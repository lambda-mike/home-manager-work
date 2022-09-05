{ pkgs, lib, config, ... }:

let
  sources = import ./nix/sources.nix;
  nixpkgsUnstable = sources."nixpkgs-unstable";
  pkgsUnstable = import nixpkgsUnstable {};
in {

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  imports = [];

  nixpkgs.overlays = [];

  home = {
    username = "mike";
    homeDirectory = "/home/mike";
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    sessionVariables = {
      # Other env vars here cause issues during fish shell startup
      EDITOR = "hx";
    };
    stateVersion = "20.09";
  };

  programs = {
    helix = {
      enable = true;
      package = pkgsUnstable.helix;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          color-modes = true;
          cursorline = true;
          indent-guides.render = true;
          line-number = "relative";
          lsp.display-messages = true;
          rulers = [ 80 ];
          scrolloff = 0;
        };
        keys.insert = {
          j = {
            j = "normal_mode";
          };
          "C-g" = "esc";
        };
        keys.normal = {
          "C-g" = "esc";
        };
      };
    };
  };
}
