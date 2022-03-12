{ pkgs, ... }:

{
  autorandr.enable = true;
  bash = {
    enable = true;
    bashrcExtra = ''
      export SHELL="${pkgs.bash}/bin/bash"
    '';
  };
  bat = {
    enable = true;
    config = { pager = "less -FR"; theme = "1337"; };
  };
  bottom.enable = true;
  broot.enable = true;
  chromium.enable = true;
  direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };
  emacs.enable = true;
  exa = {
    enable = true;
    enableAliases = true;
  };
  feh.enable = true;
  firefox.enable = true;
  gpg.enable = true;
  htop.enable = true;
  jq.enable = true;
  rofi = { enable = true; theme = "Arc-Dark"; };
  skim.enable = true;
  vscode.enable = true;
  zathura.enable = true;
  zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
  };
}
