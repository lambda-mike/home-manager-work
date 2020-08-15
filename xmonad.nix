{ pkgs, ... }:
{
  enable = true;
  enableContribAndExtras = true;
  config = pkgs.writeText "xmonad.hs" ''
  import System.Exit as E
  import           XMonad
  import qualified XMonad.StackSet as W
  import           XMonad.Util.EZConfig(additionalKeys)

  main = xmonad $
    def
      { terminal    = myTerminal
      , modMask     = mod4Mask
      , borderWidth = 2
      , normalBorderColor  = "#cccccc"
      , focusedBorderColor = "#00558c"
      } `additionalKeys` myKeysList
    where
      myTerminal = "alacritty"
      myKeysList =
        [ ((modMask              , xK_Return), spawn myTerminal)
        , ((modMask              , xK_p     ), spawn "rofi -show run")
        , ((modMask .|. shiftMask, xK_p     ), spawn "rofi -show window")
          -- %! Close the focused window
        , ((modMask .|. shiftMask, xK_q     ), kill)
          -- %! Quit xmonad
        , ((modMask .|. shiftMask, xK_e     ), io (E.exitWith E.ExitSuccess))
          -- %! Reztart xmonad
        , ((modMask              , xK_z     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
          -- %! Swap the focused window and the master window
        , ((modMask .|. shiftMask, xK_m     ), windows W.swapMaster)
        -- TODO
        -- , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        -- , ((0, xK_Print), spawn "scrot")
        ]
        ++
        -- mod-{a,r,s} %! Switch to physical/Xinerama screens 1, 2, or 3
        -- mod-shift-{a,r,s} %! Move client to screen 1, 2, or 3
        [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
            | (key, sc) <- zip [xK_a, xK_r, xK_s] [0..]
            , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
'' ;
  extraPackages = haskellPackages : [
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
    haskellPackages.xmonad
  ];
}
