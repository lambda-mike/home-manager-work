let
  createDockProfile = id:
    {
      dock = {
        config = {
          "eDP-1" = {
            crtc = 0;
            mode = "1920x1200";
            position = "0x0";
            primary = false;
            rate = "59.95";
          };
          "DP-1" = {
            crtc = 1;
            mode = "1920x1080";
            position = "1920x0";
            primary = true;
            rate = "60.00";
          };
        };
        fingerprint = {
          "eDP-1" = "00ffffffffffff004d10cb14000000002d1d0104a51d12780ede50a3544c99260f505400000001010101010101010101010101010101283c80a070b023403020360020b410000018203080a070b023403020360020b410000018000000fe005847464a30804c513133344e31000000000002410332001200000a010a202000c0";
          "DP-1" = "00ffffffffffff0009d13480010100000c1e010380351e782e0ef5a555509e26105054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c4500132a2100001e000000ff00455442334c3032363839534c30000000fd00324c1e5315000a202020202020000000fc0042656e5120424c323438330a2001cf020324f14f901f05140413031207161501061102230907078301000067030c001000002a2a4480a07038274030203500132a2100001a023a801871382d40582c4500132a2100001e011d8018711c1620582c2500132a2100009e011d007251d01e206e285500132a2100001e00000000000000000000000000000000000000ac";
        };
      };
      solo = {
        config = {
          "eDP-1" = {
            crtc = 0;
            mode = "1920x1200";
            position = "0x0";
            primary = false;
            rate = "59.95";
          };
        };
        fingerprint = {
          "eDP-1" = "00ffffffffffff004d10cb14000000002d1d0104a51d12780ede50a3544c99260f505400000001010101010101010101010101010101283c80a070b023403020360020b410000018203080a070b023403020360020b410000018000000fe005847464a30804c513133344e31000000000002410332001200000a010a202000c0";
        };
      };
    };
  soloProfile =
    {
      solo = {
        config = {
          "eDP-1" = {
            crtc = 0;
            mode = "1920x1200";
            position = "0x0";
            primary = false;
            rate = "59.95";
          };
        };
        fingerprint = {
          "eDP-1" = "00ffffffffffff004d10cb14000000002d1d0104a51d12780ede50a3544c99260f505400000001010101010101010101010101010101283c80a070b023403020360020b410000018203080a070b023403020360020b410000018000000fe005847464a30804c513133344e31000000000002410332001200000a010a202000c0";
        };
      };
    };
in
{
  enable = true;
  profiles =
    createDockProfile "1" // soloProfile;
}
