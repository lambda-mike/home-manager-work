{ pkgs, config, ... }:

{
  enable = true;
  configFile."doom" = {
    source = ./.doom.d;
    recursive = true;
  };
  configFile.".fehbg" = {
    executable = true;
    # FIXME Phase1 Download wallpaper, create symlink in ~
    text = ''
      #!/bin/sh
      ${pkgs.feh} --no-fehbg --bg-fill "${config.home.homeDirectory}/wallpaper"
    '';
  };
}
