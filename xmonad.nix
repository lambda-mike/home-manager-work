{ pkgs, ... }:
{
  enable = true;
  enableContribAndExtras = true;
  config = pkgs.writeText "xmonad.hs" ''
  import           System.Exit as E
  import           XMonad
  import qualified XMonad.StackSet as W
  import           XMonad.Util.EZConfig (additionalKeysP)

  main = xmonad $
    (config `additionalKeysP` myKeysList)
    where
      config =
        def
          { terminal           = myTerminal
          , modMask            = mod4Mask
          , borderWidth        = 2
          , normalBorderColor  = "#cccccc"
          , focusedBorderColor = "#00558c"
          }
      myTerminal =
        "alacritty"
      myKeysList =
        [ ("M-<Return>"  , spawn myTerminal               )
        , ("M-S-q"       , kill                           )
        , ("M-S-r"       , spawn restartXMonad            )
        , ("M-r"         , refresh                        )
        , ("M-S-x"       , io (E.exitWith E.ExitSuccess)  )
        , ("M-p"         , spawn "rofi -show run"         )
        , ("M-S-p"       , spawn "rofi -show window"      )
        , ("M-S-m"       , windows W.swapMaster           )
        , ("<Print>"     , screenshot SMWhole             )
        , ("M-<Print>"   , screenshot SMWindow            )
        , ("M-S-<Print>" , screenshot SMRect              )
        ]
        ++ myScreenKeybindings
      -- mod-{n,e,i} %! Switch to physical screens 1, 2, or 3
      -- mod-shift-{n,e,i} %! Move client to screen 1, 2, or 3
      myScreenKeybindings =
        [ ( mask ++ "M-" ++ [key]
          , screenWorkspace scr >>= flip whenJust (windows . action)
          )
          | (key   , scr ) <- zip "nei" [0..]
          , (action, mask) <- [ (W.view, "") , (W.shift, "S-") ]
        ]
      restartXMonad =
        "if type xmonad; then " ++
        "xmonad --recompile && xmonad --restart; " ++
        "else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"

  -- screenshot :: ScreenshotMode -> Int
  screenshot mode =
    spawn $ sleepCmd <> scrotCmd <> mvShotCmd
    where
      sleepCmd =
        "sleep 0.5; "
      scrotCmd =
        case mode of
          SMWhole  -> "scrot"
          SMWindow -> "scrot -u"
          SMRect   -> "scrot -s"
      mvShotCmd =
        " -e 'mv $f ~/Data/Screenshots/'"

  data ScreenshotMode
    = SMWhole
    | SMWindow
    | SMRect

'' ;
  extraPackages = haskellPackages : [
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad
  ];
}
