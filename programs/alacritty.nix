{
  programs = {
    alacritty =
      {
        enable = true;
        settings = {
          window = {
            padding = {
              x = 1;
              y = 1;
            };
          };
          draw_bold_text_with_bright_colors = true;
          # Kitty
          colors = {
            primary = {
              background = "0x000000";
              foreground = "0xdddddd";
            };

            normal = {
              black =   "0x000000";
              red =     "0xcc0403";
              green =   "0x19cb00";
              yellow =  "0xcecb00";
              blue =    "0x0d73cc";
              magenta = "0xcb1ed1";
              cyan =    "0x0dcdcd";
              white =   "0xdddddd";
            };

            bright = {
              black =   "0x767676";
              red =     "0xf2201f";
              green =   "0x23fd00";
              yellow =  "0xfffd00";
              blue =    "0x1a8fff";
              magenta = "0xfd28ff";
              cyan =    "0x14ffff";
              white =   "0xffffff";
            };
          };
          font = {
            normal.family = "LiberationMono";
            #normal.family = "DejaVu Sans Mono";
            #normal.family = "JetBrains Mono";
            #normal.family = "Hermit";
            size = 12;
          };
          # shell.program = "${pkgs.fish}/bin/fish";
        };
      };
  };
}
