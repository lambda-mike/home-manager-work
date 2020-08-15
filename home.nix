{ pkgs, lib, ... }:

{

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  #
  # You need to change these to match your username and home directory
  # path:
  home.username = "mike";
  home.homeDirectory = "/home/mike";

  # If you use non-standard XDG locations, set these options to the
  # appropriate paths:
  #
  # xdg.cacheHome
  # xdg.configHome
  # xdg.dataHome

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  home.packages = with pkgs; [
    brave
    du-dust
    gimp
    htop
    i3lock
    neofetch
    ripgrep
    screen
    tree
    unzip
    xsel
  ];

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

  # Since we do not install home-manager, you need to let home-manager
  # manage your shell, otherwise it will not be able to add its hooks
  # to your profile.
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
