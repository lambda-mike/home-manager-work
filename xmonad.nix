{ pkgs, ... }:
{
  enable = true;
  enableContribAndExtras = true;
  config = pkgs.writeText "xmonad.hs" ''
  import System.Exit as E
  import           XMonad
  import qualified XMonad.StackSet as W
  import           XMonad.Util.EZConfig (additionalKeysP)

  main = xmonad $
    (config `additionalKeysP` myKeysList)
    where
      config =
        def
          { terminal    = myTerminal
          , modMask     = mod4Mask
          , borderWidth = 2
          , normalBorderColor  = "#cccccc"
          , focusedBorderColor = "#00558c"
          }
      myTerminal =
        "alacritty"
      myKeysList =
        [ ("M-<Return>", spawn myTerminal     )
        , ("M-S-q"     , kill)
        , ("M-S-r"     , spawn restartXMonad )
        , ("M-r"       , refresh)
        , ("M-S-x"     , io (E.exitWith E.ExitSuccess))
        , ("M-p"       , spawn "rofi -show run")
        , ("M-S-p"     , spawn "rofi -show window")
        , ("M-S-m"     , windows W.swapMaster )
        ]
      restartXMonad =
        "if type xmonad; then " ++
        "xmonad --recompile && xmonad --restart; " ++
        "else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"

'' ;
  extraPackages = haskellPackages : [
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad
  ];
}
