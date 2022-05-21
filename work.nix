{ pkgs, lib, config, ... }:

let theme = (import ./themes.nix).blue;
    # Use direnv 2.31.0
    direnvOverlay = final: prev: {
      direnv = prev.direnv.overrideAttrs (old: rec {
        version = "2.31.0";
        src = prev.fetchFromGitHub {
          owner = "direnv";
          repo = "direnv";
          rev = "v${version}";
          sha256 = "sha256-s3IzckePNjr8Bo4kDXj3/WJgybirvtBd9hW2+eWPorA=";
        };
        vendorSha256 = "sha256-YhgQUl9fdictEtz6J88vEzznGd8Ipeb9AYo/p1ZLz5k=";
      });
    };
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
    (import ./services/polybar.nix theme)
    ./services/redshift.nix
    ./services/screen-locker.nix
    (import ./xdg.nix theme)
    ./xsession.nix
    ./cursor.nix
  ];

  nixpkgs.overlays = [
    direnvOverlay
  ];

  home = {
    username = "mike";
    homeDirectory = "/home/mike";
    packages = import ./core/packages.nix { inherit pkgs; } ++ (with pkgs; [
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
