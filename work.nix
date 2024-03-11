{ pkgs, config, ... }:

let
  theme = (import ./themes.nix).blue;
  windowManager = "xmonad";
in {

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  imports = [
    ./cursor.nix
    ./programs/alacritty.nix
    ./programs/fish.nix
    ./programs/git.nix
    ./programs/kakoune.nix
    ./programs/keychain.nix
    ./programs/neovim.nix
    ./programs/ssh.nix
    ./programs/tmux.nix
    ./services/gpg-agent.nix
    ./services/redshift.nix
    ./services/screen-locker.nix
    (import ./services/polybar.nix { inherit theme windowManager; })
    (import ./xdg.nix theme)
    (import ./xsession.nix { inherit windowManager; })
  ];

  nixpkgs.overlays = [ ];

  home = {
    username = "mike";
    homeDirectory = "/home/mike";
    file = import ./homeFile.nix { inherit config; };
    packages = import ./core/packages.nix { inherit pkgs; } ++ (with pkgs; [
    ]);
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    sessionVariables = {
      # Other env vars here cause issues during fish shell startup
      EDITOR = "hx";
    };
    stateVersion = "20.09";
  };

  fonts.fontconfig.enable = true;

  programs = import ./core/programs.nix theme { inherit pkgs; } // {
    # Overwrite programs here
  };

  xsession.windowManager = import ./xmonad.nix theme { inherit pkgs; };

  # FIXME create keys.nix
  # FIXME programs.git.userName
  # FIXME programs.git.userEmail
  # FIXME services/redshift.nix coords
  # FIXME xdg.nix ~/wallpaper
}
