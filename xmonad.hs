import qualified Data.Map.Strict as M
import qualified DBus as D
import qualified DBus.Client as D
import qualified System.Exit as E
import           XMonad hiding ( (|||) )
import qualified XMonad.Actions.CycleWS as CWS
import           XMonad.Actions.Submap (submap)
import           XMonad.Config.Desktop (desktopConfig)
import           XMonad.Hooks.ManageDocks (ToggleStruts(..), avoidStruts)
import           XMonad.Hooks.ManageHelpers (doCenterFloat, isDialog)
import           XMonad.Hooks.SetWMName (setWMName)
import           XMonad.Layout.Fullscreen
  ( fullscreenEventHook
  , fullscreenManageHook
  )
import           XMonad.Layout.LayoutCombinators
  ( (|||)
  , JumpToLayout(JumpToLayout)
  )
import           XMonad.Layout.MultiToggle (Toggle(..), mkToggle, single)
import           XMonad.Layout.MultiToggle.Instances (StdTransformers(FULL))
import           XMonad.Layout.NoBorders (smartBorders)
import           XMonad.Layout.Renamed (Rename(Replace), renamed)
import qualified XMonad.Layout.Tabbed as T
import           XMonad.Layout.ThreeColumns (ThreeCol(ThreeCol))
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
    , normalBorderColor  = colourNordBlue
    , focusedBorderColor = colourLightBlue
    , focusFollowsMouse  = True
    , handleEventHook    = handleEventHook desktopConfig <+> fullscreenEventHook
    , layoutHook         = myLayout
    , manageHook         =
        myManageHook <+> manageHook desktopConfig <+> fullscreenManageHook
    , startupHook        = myStartupHook <+> startupHook desktopConfig
    }

myTerminal =
  "alacritty"

myManageHook = composeAll . concat $
  [ [isDialog --> doCenterFloat]
  , [className =? c --> doCenterFloat | c <- myCFloats]
  , [title =? t --> doFloat | t <- myTFloats]
  ]
  where
    myCFloats = ["VirtualBox Manager", "Gimp"]
    myTFloats = ["Downloads", "Save As..."]

myStartupHook = do
  setWMName "LG3D"
  -- Make sure polybar reads data from XMonad correctly
  spawn "polybar-msg cmd restart"

myKeysList =
  [ ("M-<Return>"  , spawn myTerminal              )
  , ("M-S-q"       , kill                          )
  , ("M-S-r"       , spawn restartXMonad           )
  , ("M-r"         , refresh                       )
  , ("M-S-x"       , io (E.exitWith E.ExitSuccess) )
  , ("M-p"         , spawn "rofi -show run"        )
  , ("M-S-p"       , spawn "rofi -show window"     )
  , ("M-l"         , sendMessage NextLayout        )
  , ("M-S-l"       , resetLayout                   )
  , ("M-f"         , toggleFullscreen              )
  , ("M-t"         , setTabbedLayout               )
  , ("M-c"         , setColumnLayout               )
  , ("M-S-t"       , pushWinBackToTiling           )
  , ("M-S-m"       , windows W.swapMaster          )
  , ("<Print>"     , screenshot SMWhole            )
  , ("M-<Print>"   , screenshot SMWindow           )
  , ("M-S-<Print>" , screenshot SMRect             )
  , ("M-w"         , CWS.toggleWS                  )
  ]
  ++ myScreenKeybindings
  ++ mySysCtrlSubmapKeybindings
  where
    restartXMonad =
      "if type xmonad; then " ++
      "xmonad --recompile && xmonad --restart; " ++
      "else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"
    -- mod-{n,e,i} %! Switch to physical screens 1, 2, or 3
    -- mod-shift-{n,e,i} %! Move client to screen 1, 2, or 3
    myScreenKeybindings =
      [ ( mask ++ "M-" ++ [key]
          , screenWorkspace scr >>= flip whenJust (windows . action)
        )
      | (key   , scr ) <- zip "nei" [0..]
      , (action, mask) <- [ (W.view, "") , (W.shift, "S-") ]
      ]
    mySysCtrlSubmapKeybindings =
      [ ("M-0", submap . M.fromList $
          [ ((0        , xK_h), spawn "systemctl hibernate"   )
          , ((0        , xK_s), spawn "systemctl suspend"     )
          , ((shiftMask, xK_s), spawn "systemctl poweroff"    )
          , ((0        , xK_r), spawn "systemctl reboot"      )
          , ((0        , xK_l), spawn "~/.config/lock-screen" )
          ]
        )
      ]
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

resetLayout =
  setLayout
  $ Layout
  $ XMonad.layoutHook myConfig

pushWinBackToTiling =
  withFocused $ windows . W.sink

setTabbedLayout =
  sendMessage
  $ JumpToLayout
  $ description myTabLayout

setColumnLayout =
  sendMessage
  $ JumpToLayout
  $ description myColLayout

toggleFullscreen = do
  sendMessage $ Toggle FULL
  sendMessage ToggleStruts

myLayout = id
  $ avoidStruts
  $ smartBorders
  $ mkToggle (single FULL)
  $ myTiledLayout
  ||| Mirror myTiledLayout
  ||| myTabLayout
  ||| myColLayout
  ||| Full

-- default tiling algorithm partitions the screen into two panes
myTiledLayout = Tall nmaster delta ratio
  where
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio = 1/2
    -- Percent of screen to increment by when resizing panes
    delta = 3/100

myTabLayout =
  renamed [Replace "MyTabbed"]
  $ T.tabbedBottom T.shrinkText
  $ T.def -- Tabs theme modified below
    { T.activeColor         = colourLightBlue
    , T.inactiveColor       = colourNordBlue
    , T.activeBorderColor   = colourDarkBlue
    , T.inactiveBorderColor = colourDarkBlue
    , T.activeTextColor     = colourWhite
    , T.inactiveTextColor   = colourGrey
    }

myColLayout =
  renamed [Replace "MyColumn"]
  $ ThreeCol 1 (3/100) (1/3)

-- Colours
colourDarkBlue = "#00558c"
colourLightBlue = "#0076cf"
colourNordBlue = "#2f343f"
colourWhite = "#fefefe"
colourGrey = "#bebebe"

data ScreenshotMode
  = SMWhole
  | SMWindow
  | SMRect
