{ pkgs, lib, ... }:

{

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  home = {
    username = "mike";
    homeDirectory = "/home/mike";
    packages = with pkgs; [
      brave
      du-dust
      fd
      gimp
      git-crypt
      htop
      i3lock
      libreoffice
      linuxPackages_5_7.virtualbox
      linuxPackages_5_7.virtualboxGuestAdditions
      neofetch
      pinentry
      python38
      ripgrep
      rustup
      scrot
      screen
      tree
      unzip
      virtualbox
      xsel
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "20.09";
  };

  services = {
    # gpgconf --reload gpg-agent should make pinentry available
    gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
    };
    screen-locker = {
      enable = true;
      inactiveInterval = 10;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 00558c";
    };
  };

  xsession.enable = true;
  xsession.windowManager.xmonad = import ./xmonad.nix { inherit pkgs; };

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
    };
    skim.enable = true;
    tmux = import ./tmux.nix { inherit pkgs; };
    vscode = { enable = true; };
    zathura = { enable = true; };
  };

  services = {
    redshift = import ./redshift.nix;
  };

  xdg = import ./xdg.nix;

}
