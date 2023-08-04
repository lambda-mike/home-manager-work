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
        soft-wrap.enable = true;
        statusline.right = [
          "diagnostics" "separator"
          "selections" "primary-selection-length" "separator"
          "position" "total-line-numbers" "position-percentage" "file-encoding"
        ];
        statusline.left = [ "mode" "spinner" "version-control" "file-name" ];
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
          space.E = ":reload-all";
          space.b.b = "buffer_picker";
          space."," = "buffer_picker";
          space.b.k = ":buffer-close";
          space.b.K = ":buffer-close!";
          space.b.N = ":new";
          space.b.o = ":buffer-close-others";
          space.b.O = ":buffer-close-others!";
          space.b.s = ":write";
          space.b.S = ":write-all";
          space.f.f = "file_picker";
          space.f.F = "file_picker_in_current_buffer_directory";
          space.space = "file_picker_in_current_directory";
          space.f.s = ":write";
          space.w.c = "wclose";
          space.c = "toggle_comments";
          space.m.i = ":toggle-option lsp.display-inlay-hints";
          space.m.f = ":pipe pnpm exec prettier --parser typescript";
          space.m.r = ":reflow 80";
          "C-/" = "toggle_comments";
          "A-/" = "toggle_comments";
          Z.Z = ":write-quit";
          "H" = "goto_window_top";
          "M" = "goto_window_center";
          "L" = "goto_window_bottom";
          "G" = "goto_last_line";
          "ret" = ["move_line_down" "goto_first_nonwhitespace"];
          "minus" = ["move_line_up" "goto_first_nonwhitespace"];
          "{" = "goto_prev_paragraph";
          "}" = "goto_next_paragraph";
        };
      };
    };
    languages = {
      language = [
        {
          name = "nim";
          language-server.command = "nimlsp";
        }
        {
          name = "nix";
          language-server.command = "nil";
        }
        {
          name = "unison";
          scope = "source.unison";
          "injection-regex" = "unison";
          "file-types" = ["u"];
          shebangs = [];
          roots = [];
          "auto-format" = false;
          "comment-token" = "--";
          indent = { "tab-width" = 4; unit = "    "; };
          "language-server" = { command = "nc"; args = ["localhost" "5757"]; };
        }
      ];
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
