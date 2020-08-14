{ pkgs, ... }:

{
  enable = true;
  config = {
    colorScheme = "base16";
    indentWidth = 2;
    keyMappings = [
      {
        docstring = "move down";
        effect = "j";
        key = "<c-n>";
        mode = "normal";
      }
      {
        docstring = "go to first non-blank character in the next line";
        effect = "jgi";
        key = "<ret>";
        mode = "normal";
      }
      {
        docstring = "go to first non-blank character in the next line";
        effect = "jgi";
        key = "<plus>";
        mode = "normal";
      }
      {
        docstring = "go to first non-blank character in the previous line";
        effect = "kgi";
        key = "<minus>";
        mode = "normal";
      }
      {
        docstring = "delete to end of line";
        effect = "<a-l>d";
        key = "D";
        mode = "normal";
      }
      {
        docstring = "yank to end of line";
        effect =  "<a-l>y";
        key = "Y";
        mode = "normal";
      }
      {
        docstring = "format buffer";
        effect = ":format<ret>";
        key = "=";
        mode = "normal";
      }
      {
        docstring = "go to line beginning";
        effect = "gh";
        key = "0";
        mode = "normal";
      }
      {
        docstring = "go to beginning of the last line";
        effect = "j";
        key = "G";
        mode = "goto";
      }
      {
        docstring = "comment line";
        effect = ":comment-line<ret>";
        key = "'#'";
        mode = "normal";
      }
      {
        docstring = "comment block";
        effect = ":comment-block<ret>";
        key = "<a-#>";
        mode = "normal";
      }
    ];
    numberLines = {
      enable = true;
      highlightCursor = true;
      relative = true;
    };
    scrollOff.lines = 3;
    showMatching = true;
    wrapLines = {
      enable = true;
      marker =  "⏎";
    };
  };
  extraConfig = ''
    set-option global fzf_file_command 'rg'
    set-option global fzf_implementation 'sk'
'';
  plugins = [
    pkgs.kakounePlugins.kak-fzf
  ];
}
