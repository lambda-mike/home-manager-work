{ pkgs, lib, config, ... }:

let theme = (import ./themes.nix).blue;
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
    packages = [ pkgs.nil ];
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
    helix = (import ./core/programs.nix theme { inherit pkgs; }).helix;
  };
}
