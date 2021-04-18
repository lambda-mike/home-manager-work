{ pkgs, lib, config, ... }:

# blue or green
let theme = "green";
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
    packages = import ./core/packages.nix { inherit pkgs; } ++ (with pkgs; [
      # linuxPackages_5_9.virtualbox
      # linuxPackages_5_9.virtualboxGuestAdditions
      # virtualbox
    ]);
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    sessionVariables = {
      # Other env vars here cause issues during fish shell startup
      EDITOR = "nvim";
    };
    stateVersion = "20.09";
  };

  fonts.fontconfig.enable = true;

  programs = {
    autorandr.enable = true;
    bash.enable = true;
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
}
