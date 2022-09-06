theme:
{ pkgs, ... }:

let
  sources = import ../nix/sources.nix;
  nixpkgsUnstable = sources."nixpkgs-unstable";
  pkgsUnstable = import nixpkgsUnstable {};
in {
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
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };
  emacs.enable = true;
  exa = {
    enable = true;
    enableAliases = true;
  };
  feh.enable = true;
  firefox.enable = true;
  gpg.enable = true;
  helix = {
    enable = true;
    package = pkgsUnstable.helix;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        color-modes = true;
        cursorline = true;
        indent-guides.render = true;
        line-number = "relative";
        lsp.display-messages = true;
        rulers = [ 80 ];
        scrolloff = 0;
      };
      keys = {
        insert = {
          j.j = "normal_mode";
        };
        normal = {
          space.q = ":q";
        };
      };
    };
  };
  htop.enable = true;
  jq.enable = true;
  rofi = {
    enable = true;
    font = "${theme.font} 14";
    theme = theme.rofi;
  };
  skim.enable = true;
  tealdeer.enable = true;
  vscode.enable = true;
  zathura.enable = true;
  zellij.enable = true;
  zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
  };
}
