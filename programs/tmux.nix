{ pkgs, ... }:

{
  programs = {
    tmux =
      {
        clock24 = true;
        enable = true;
        escapeTime = 50;
        extraConfig = ''
set -g status off
set -g status-keys vi
set -g status-position top
# Programs won't rename window name
set -g allow-rename off
# Toggle status bar
bind-key a { set status }
bind-key C-b { last-window }
  '';
        historyLimit = 10000;
        keyMode = "vi";
        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.resurrect;
            extraConfig = "set -g @resurrect-strategy-nvim 'session'";
          }
        ];
        terminal = "screen-256color";
      };
  };
}
