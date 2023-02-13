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
    themes = {
      my_catppuccin_mocha = {
        inherits = "catppuccin_mocha";
        "diagnostic.error" = { underline = { style = "curl"; color = "red"; }; };
      };
    };
    settings = {
      theme = "my_catppuccin_mocha";
      editor = {
        bufferline = "multiple";
        color-modes = true;
        cursorline = true;
        cursor-shape.insert = "bar";
        file-picker.hidden = false;
        indent-guides.render = true;
        line-number = "relative";
        lsp.display-messages = true;
        rulers = [ 80 ];
        scrolloff = 0;
        statusline.right = [
          "diagnostics" "separator"
          "selections" "primary-selection-length" "separator"
          "position" "total-line-numbers" "position-percentage" "file-encoding"
        ];
        statusline.left = [ "mode" "spinner" "file-name" ];
        whitespace.render = "all";
      };
      keys = {
        insert = {
          j.j = "normal_mode";
        };
        normal = {
          space.q.q = ":quit";
          space.q.Q = ":quit!";
          space.q.a = ":quit-all";
          space.q.A = ":quit-all!";
          space.q.x = ":write-quit-all";
          space.q.X = ":write-quit-all!";
          space.e = ":reload";
          space.b.b = "buffer_picker";
          space.b.c = ":buffer-close";
          space.b.C = ":buffer-close!";
          space.b.N = ":new";
          space.f.f = "file_picker";
          space.f.F = "file_picker_in_current_directory";
          space.space = "file_picker_in_current_directory";
          space.f.s = ":write";
          space.w.c = "wclose";
          space.c.c = "toggle_comments";
          Z.Z = ":write-quit";
          "H" = "goto_window_top";
          "M" = "goto_window_center";
          "L" = "goto_window_bottom";
          "ret" = "move_line_down";
          "minus" = "move_line_up";
        };
      };
    };
    languages = [
      {
        name = "nix";
        language-server.command = "nil";
      }
    ];
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
