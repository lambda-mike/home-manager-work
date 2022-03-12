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
    (import ./services/polybar.nix theme)
    ./services/redshift.nix
    ./services/screen-locker.nix
    # TODO investigate if theme is green inside
    (import ./xdg.nix theme)
    ./xsession.nix
  ];

  home = {
    username = "mike";
    homeDirectory = "/home/mike";
    packages = import ./core/packages.nix { inherit pkgs; } ++ (with pkgs; [
    ]);
    file = import ./homeFile.nix { inherit config; };
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

  programs = import ./core/programs.nix { inherit pkgs; } // {
    # Overwrite programs here
  };

  xsession.windowManager = import ./xmonad.nix theme { inherit pkgs; };
}
