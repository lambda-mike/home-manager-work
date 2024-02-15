theme:
{ pkgs, config, ... }:
let bgColour = builtins.substring 1 6 theme.colours.lock;
    mainDark = theme.colours.mainDark;
    mainLight = theme.colours.mainLight;
    emacsProfiles = import ./emacsProfiles.nix;
in {
  xdg = {
    enable = true;
    configFile."${emacsProfiles.doom}" = {
      source = ./.doom.d;
      recursive = true;
    };
    configFile."fehbg" = {
      executable = true;
      # FIXME Phase1 Download wallpaper, create symlink in ~
      text = ''
      #!/usr/bin/env sh
      ${pkgs.feh}/bin/feh --no-fehbg --bg-fill ${config.home.homeDirectory}/wallpaper
    '';
    };
    configFile."lock-screen" = {
      executable = true;
      text = ''
      #!/usr/bin/env sh
      ${pkgs.i3lock}/bin/i3lock -n -c ${bgColour}
    '';
    };
    configFile."copy-to-clip" = {
      executable = true;
      text = ''
      #! /usr/bin/env sh
      echo "$(pwd)/$1" | xsel -bi
    '';
      onChange = ''
      #! /usr/bin/env sh
      mkdir -p ${config.home.homeDirectory}/.local/bin
    '';
      target = ''../.local/bin/copy-to-clip'';
    };
    configFile."greenclip.toml" = {
      text = ''
[greenclip]
  blacklisted_applications = []
  enable_image_support = true
  history_file = "${config.home.homeDirectory}/.cache/greenclip.history"
  image_cache_directory = "/tmp/greenclip"
  max_history_length = 500
  max_selection_size_bytes = 0
  static_history = []
  trim_space_from_selection = true
  use_primary_selection_as_input = false
    '';
    };
    configFile.leftwm = {
      source = ./leftwm;
      recursive = true;
    };
    configFile."leftwm/themes/basic/theme.ron" = {
      text = ''
(
  border_width: 2,
  margin: 0,
  default_border_color: "#2f343f",
  floating_border_color: "${mainDark}",
  focused_border_color: "${mainLight}",
)
      '';
    };
  };
}
