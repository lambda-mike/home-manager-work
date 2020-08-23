import qualified DBus as D
import qualified DBus.Client as D
import qualified System.Exit as E
import           XMonad
import           XMonad.Config.Desktop (desktopConfig)
import           XMonad.Hooks.EwmhDesktops (fullscreenEventHook)
import           XMonad.Hooks.ManageDocks (avoidStruts)
import           XMonad.Hooks.ManageHelpers (doCenterFloat, isDialog)
import           XMonad.Hooks.SetWMName (setWMName)
import           XMonad.Layout.NoBorders (smartBorders)
import           XMonad.ManageHook (composeAll)
import qualified XMonad.StackSet as W
import           XMonad.Util.EZConfig (additionalKeysP)

main = do
  dbus <- D.connectSession
  -- Request access to the DBus name
  D.requestName dbus (D.busName_ "org.xmonad.Log")
    [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

  xmonad $
    (myConfig `additionalKeysP` myKeysList)

myConfig =
  desktopConfig
    { terminal           = myTerminal
    , modMask            = mod4Mask
    , borderWidth        = 2
    , normalBorderColor  = "#2f3d44"
    , focusedBorderColor = "#0076cf"
    , focusFollowsMouse  = True
    , handleEventHook    = handleEventHook desktopConfig <+> fullscreenEventHook
    , layoutHook         = myLayout
    , manageHook         = myManageHook <+> manageHook desktopConfig
    , startupHook        = myStartupHook <+> startupHook desktopConfig
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
  -- TODO fix so it shows windows??
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

myStartupHook = do
  setWMName "LG3D"
  spawn "polybar-msg cmd restart"

myLayout = id
  $ avoidStruts
  $ smartBorders
  $ tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myManageHook = composeAll . concat $
  [ [isDialog --> doCenterFloat]
  , [className =? c --> doCenterFloat | c <- myCFloats]
  , [title =? t --> doFloat | t <- myTFloats]
  ]
  where
    myCFloats = ["VirtualBox Manager", "Gimp"]
    myTFloats = ["Downloads", "Save As..."]
