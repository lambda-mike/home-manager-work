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
    ./programs/alacritty.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./services/gpg-agent.nix
    ./services/polybar.nix
    ./services/redshift.nix
    ./services/screen-locker.nix
    ./xdg.nix
    # TODO move xmonad ouf from xsession make it fn
    ./xsession.nix
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
      nnn
      nodePackages.typescript-language-server
      pinentry
      python38
      ripgrep
      rustup
      scrot
      screen
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
    autorandr = import ./autorandr.nix;
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
    kakoune = import ./kakoune.nix { inherit pkgs; };
    keychain = import ./keychain.nix;
    neovim = import ./neovim.nix { inherit pkgs; };
    rofi = { enable = true; theme = "Arc-Dark"; };
    skim.enable = true;
    tmux = import ./tmux.nix { inherit pkgs; };
    vscode.enable = true;
    zathura.enable = true;
  };

}
