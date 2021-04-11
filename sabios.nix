{ pkgs, lib, config, ... }:

{

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  imports = [
    #./services/redshift.nix
  ];

  home = {
    username = "sabi";
    homeDirectory = "/home/sabi";
    packages = with pkgs; [
      brave
      gimp
      git
      htop
      libreoffice
      megasync
      obs-studio
      screen
      skype
      tree
      unzip
      zoom-us
    ];
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    stateVersion = "20.09";
  };

  programs = {
    bash = {
      bashrcExtra = builtins.readFile ./sabios/.bashrc;
      enable = true;
      historyControl = [ "ignoredups" ];
      profileExtra = ''
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
'';
    };
    fish.enable = true;
    #chromium.enable = true;
  };

  # FIXME create keys.nix
  # FIXME services/redshift.nix coords
}
