{ pkgs, lib, config, ... }:

let theme = "blue";
in {

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  imports = [
    ./programs/alacritty.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/kakoune.nix
    ./programs/keychain.nix
    ./programs/neovim.nix
    ./programs/tmux.nix
    ./services/gpg-agent.nix
    ./services/redshift.nix
    ./services/screen-locker.nix
    ./xsession.nix
  ];

  home = {
    username = "mike";
    homeDirectory = "/home/mike";
    packages = with pkgs; [
      brave
      docker
      du-dust
      exa
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
      nnn
      nodePackages.typescript-language-server
      pinentry
      procs
      python38
      ripgrep
      rustup
      scrot
      screen
      shellcheck
      tokei
      tree
      unzip
      # virtualbox
      xorg.xbacklight
      xorg.xdpyinfo
      xsel
    ];
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    sessionVariables = {
      # Other env vars here cause issues during fish shell startup
      EDITOR = "nvim";
    };
    stateVersion = "20.09";
  };

  programs = {
    autorandr.enable = true;
    bat = {
      enable = true;
      config = { pager = "less -FR"; theme = "1337"; };
    };
    broot.enable = true;
    chromium.enable = true;
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
    emacs.enable = true;
    feh.enable = true;
    firefox.enable = true;
    gpg.enable = true;
    jq.enable = true;
    rofi = { enable = true; theme = "Arc-Dark"; };
    skim.enable = true;
    vscode.enable = true;
    zathura.enable = true;
  };

  services.polybar = import ./services/polybar.nix theme { inherit pkgs lib; };
  xdg = import ./xdg.nix theme { inherit pkgs config; };
  xsession.windowManager = import ./xmonad.nix theme { inherit pkgs; };

  # FIXME create keys.nix
  # FIXME programs.git.userName
  # FIXME programs.git.userEmail
  # FIXME services/redshift.nix coords
  # FIXME xdg.nix ~/wallpaper
}
