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
      simple-scan
      htop
      libreoffice
      megasync
      obs-studio
      pcloud
      screen
      skypeforlinux
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
    fish = {
      enable = true;
      shellInit = ''set -g -x fish_key_bindings fish_vi_key_bindings'';
    };
    #chromium.enable = true;
  };
  xdg = {
    enable = true;
    configFile.".screenrc" = {
      text = ''
screen fish -l
shell fish
      '';
    };
  };

  # FIXME services/redshift.nix coords
}
