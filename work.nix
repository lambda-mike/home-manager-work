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
    ./services/gpg-agent.nix
    ./services/screen-locker.nix
    ./xdg.nix
  ];

  home = {
    username = "mike";
    homeDirectory = "/home/mike";
    packages = with pkgs; [
      brave
      docker
      du-dust
      fd
      file
      font-awesome
      gimp
      git-crypt
      haskellPackages.greenclip
      htop
      i3lock
      libreoffice
      # linuxPackages_5_9.virtualbox
      # linuxPackages_5_9.virtualboxGuestAdditions
      neofetch
      ncompress
      nixfmt
      nodePackages.typescript-language-server
      pinentry
      python38
      ripgrep
      rustup
      scrot
      screen
      tree
      unzip
      virtualbox
      xorg.xbacklight
      xorg.xdpyinfo
      xsel
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "20.09";
  };

  xsession = import ./xsession.nix { inherit pkgs config; };

  programs = {
    autorandr = import ./autorandr.nix;
    alacritty = import ./alacritty.nix;
    bat = {
      enable = true;
      config = { pager = "less -FR"; theme = "1337"; };
    };
    broot = {
      enable = true;
    };
    chromium.enable = true;
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
    emacs.enable = true;
    feh.enable = true;
    firefox = {
      enable = true;
    };
    fish = import ./fish.nix;
    gpg = {
      enable = true;
    };
    git = import ./git.nix;
    jq = {
      enable = true;
    };
    kakoune = import ./kakoune.nix { inherit pkgs; };
    keychain = import ./keychain.nix;
    neovim = import ./neovim.nix { inherit pkgs; };
    rofi = {
      enable = true;
      theme = "Arc-Dark";
    };
    skim.enable = true;
    tmux = import ./tmux.nix { inherit pkgs; };
    vscode = { enable = true; };
    zathura = { enable = true; };
  };

  services = {
    polybar = import ./polybar.nix { inherit pkgs lib; };
    redshift = import ./redshift.nix;
  };

}
