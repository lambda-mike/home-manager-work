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
      htop
      i3lock
      neofetch
      ripgrep
      rustup
      screen
      tree
      unzip
      xsel
    ];
    stateVersion = "20.09";
  };

  services.screen-locker = {
    enable = true;
    inactiveInterval = 10;
    lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 00558c";
  };

  xsession.enable = true;

  # xsession.windowManager.i3 = {
  #   enable = false;
  #   config =
  #     let mod = "Mod4";
  #     in {
  #       modifier = mod;
  #       workspaceAutoBackAndForth = true;
  #       keybindings =
  #           lib.mkOptionDefault {
  #             "${mod}+Return" = "exec alacritty";
  #           };
  #     };
  # };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = pkgs.writeText "xmonad.hs" ''
  import XMonad
  main = xmonad def
      { terminal    = "alacritty"
      , modMask     = mod4Mask
      , borderWidth = 2
      }
'' ;
    extraPackages = haskellPackages : [
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      haskellPackages.xmonad
    ];
  };
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

}
