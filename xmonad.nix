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
        [ ("M-<Return>", spawn myTerminal               )
        , ("M-S-q"     , kill                           )
        , ("M-S-r"     , spawn restartXMonad            )
        , ("M-r"       , refresh                        )
        , ("M-S-x"     , io (E.exitWith E.ExitSuccess)  )
        , ("M-p"       , spawn "rofi -show run"         )
        , ("M-S-p"     , spawn "rofi -show window"      )
        , ("M-S-m"     , windows W.swapMaster           )
        -- TODO
        -- , ((0, xK_Print), spawn "scrot")
        -- , ((shift, xK_Print), spawn "sleep 0.2; scrot -u") -- window
        -- , ((shift control, xK_Print), spawn "sleep 0.2; scrot -s") -- rect
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

'' ;
  extraPackages = haskellPackages : [
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad
  ];
}
