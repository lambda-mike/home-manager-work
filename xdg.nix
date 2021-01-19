{ pkgs, config, ... }:

{
  xdg = {
    enable = true;
    configFile."doom" = {
      source = ./.doom.d;
      recursive = true;
    };
    configFile."fehbg" = {
      executable = true;
      # FIXME Phase1 Download wallpaper, create symlink in ~
      text = ''
        #!/bin/sh
        ${pkgs.feh}/bin/feh --no-fehbg --bg-fill ${config.home.homeDirectory}/wallpaper
      '';
    };
    configFile."lock-screen" = {
      executable = true;
      text = ''
        #!/bin/sh
        ${pkgs.i3lock}/bin/i3lock -n -c 00558c
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
    configFile."greenclip.cfg" = {
      text = ''
Config {
  maxHistoryLength = 500,
  historyPath = "~/.cache/greenclip.history",
  staticHistoryPath = "~/.cache/greenclip.staticHistory",
  imageCachePath = "/tmp/greenclip/",
  usePrimarySelectionAsInput = False,
  blacklistedApps = [],
  trimSpaceFromSelection = True,
  enableImageSupport = True
}
      '';
    };
  };
}
