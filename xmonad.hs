import           Control.Monad (join, when)
import           Data.Function (on)
import           Data.List (partition, sortBy)
import qualified Data.Map.Strict as M
import qualified DBus as D
import qualified DBus.Client as D
import qualified System.Exit as Ex
import           XMonad hiding ( (|||) )
import qualified XMonad.Actions.CycleWS as CWS
import           XMonad.Actions.OnScreen
  ( Focus(FocusCurrent)
  , greedyViewOnScreen
  , onScreen'
  )
import           XMonad.Actions.SpawnOn (manageSpawn, spawnOn)
import           XMonad.Actions.Submap (submap)
import           XMonad.Actions.UpdatePointer (updatePointer)
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
import           XMonad.Prompt (XPrompt)
import qualified XMonad.Prompt.ConfirmPrompt as CP
import qualified XMonad.Prompt as PT
import qualified XMonad.StackSet as W
import           XMonad.Util.EZConfig (additionalKeysP, removeKeysP)

-- all colours variables are located in xmonad.theme.hs file

main = do
  dbus <- D.connectSession
  -- Request access to the DBus name
  D.requestName dbus (D.busName_ "org.xmonad.Log")
    [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

  spawn $ "touch " ++ myWorkspacesLog

  xmonad
    . (flip additionalKeysP myKeysList)
    . (flip removeKeysP myKeysToDelete)
    $ myConfig

myConfig =
  desktopConfig
    { workspaces         = myWorkspaces
    , terminal           = myTerminal
    , modMask            = mod4Mask
    , borderWidth        = 2
    , normalBorderColor  = colourDark
    , focusedBorderColor = colourMainLight
    , focusFollowsMouse  = True
    , handleEventHook    = handleEventHook desktopConfig <+> fullscreenEventHook
    , layoutHook         = myLayout
    , logHook            =
        logHook desktopConfig <+>
        myWorspacesHook >>
        centerPointerWhenSwitchingScreensHook
    , manageHook         =
        myManageHook <+>
        manageSpawn <+>
        manageHook desktopConfig <+>
        fullscreenManageHook
    , startupHook        = myStartupHook <+> startupHook desktopConfig
    }

myWorkspaces :: [WorkspaceId]
myWorkspaces =
  map show [1 .. 9 :: Int]

myTerminal =
  "alacritty"

centerPointerWhenSwitchingScreensHook = updatePointer (0.5, 0.5) (0, 0)

myWorspacesHook = do
  winset <- gets windowset
  let currWs = W.currentTag winset
  let visibleNotCurrentWs =
        filter (/= currWs)
        . map (W.tag . W.workspace)
        . W.visible
        $ winset
  let otherWs =
        take 6 -- take max 3 other screens
        . concat
        . map (<> " ")
        $ visibleNotCurrentWs
  let currWsLayout = W.layout . W.workspace . W.current $ winset
  let result = otherWs <> description currWsLayout <> "\n"
  io $ writeFile myWorkspacesLog result

myWorkspacesLog =
  "/tmp/.xmonad-workspace-log"

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
  winset <- gets windowset
  let isFreshStartup = W.allWindows winset == []
  when isFreshStartup $ freshStartupHook winset
  where
    freshStartupHook winset = do
      setTabbedLayout
      let visibleScreens = W.visible winset
      let workspace5Tag = myWorkspaces !! 4
      when (length visibleScreens > 0) $ do
        let otherScreen = W.screen . head $ visibleScreens
        windows $ greedyViewOnScreen otherScreen workspace5Tag
        onScreen' toggleFullscreen FocusCurrent otherScreen
      spawnOn (myWorkspaces !! 0) "brave"
      spawnOn (myWorkspaces !! 1) (myTerminal <> " -e tmux")
      spawnOn (myWorkspaces !! 2) "emacs"

-- Default keybinings
{-
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
-}

myKeysList =
  [ ("M-<Return>"  , spawn myTerminal       )
  , ("M-S-q"       , kill                   )
  , ("M-S-r"       , spawn restartXMonad    )
  , ("M-r"         , refresh                )
  , ("M-S-x"       , myExitXMonad           )
  , ("M-S-l"       , lockScreen             )
  , ("M-p"         , rofiRun                )
  , ("M-S-p"       , rofiWindow             )
  , ("M-y"         , callGreenclip          )
  , ("M-u"         , sendMessage NextLayout )
  , ("M-S-u"       , resetLayout            )
  , ("M-S-f"       , toggleFullscreen       )
  , ("M-f"         , setFullLayout          )
  , ("M-t"         , setTabbedLayout        )
  , ("M-c"         , setColumnLayout        )
  , ("M-S-t"       , pushWinBackToTiling    )
  , ("M-S-m"       , windows W.swapMaster   )
  , ("<Print>"     , screenshot SMWhole     )
  , ("M-<Print>"   , screenshot SMWindow    )
  , ("M-S-<Print>" , screenshot SMRect      )
  , ("M-w"         , CWS.toggleWS           )
  , ("M-o"         , CWS.swapNextScreen     )
  , ("M-S-o"       , CWS.swapPrevScreen     )
  , ("M-a"         , CWS.nextScreen         )
  , ("M-S-a"       , CWS.shiftNextScreen    )
  , ("M-v"         , CWS.prevScreen         )
  , ("M-S-v"       , CWS.shiftPrevScreen    )
  , ("M-]"         , CWS.nextWS             )
  , ("M-S-]"       , CWS.shiftToNext        )
  , ("M-["         , CWS.prevWS             )
  , ("M-S-["       , CWS.shiftToPrev        )
  , ("M-0"         , exitMenuPrompt         )
  ]
  ++ myFnKeybindings
  ++ myScreenKeybindings
  ++ myWorkspacesKeybindings
  where
    myFnKeybindings =
      let audio = "Master"
      in [ ("<XF86AudioLowerVolume>" , spawn $ "amixer -q set " <> audio <> " 5%-"    )
         , ("<XF86AudioRaiseVolume>" , spawn $ "amixer -q set " <> audio <> " 5%+"    )
         , ("<XF86AudioMute>"        , spawn $ "amixer -q set " <> audio <> " toggle" )
         ]
    -- mod-{n,e,i} %! Switch to physical screens 1, 2, or 3
    -- mod-shift-{n,e,i} %! Move client to screen 1, 2, or 3
    myScreenKeybindings =
      [ ( mask ++ "M-" ++ [key]
          , screenWorkspace scr >>= flip whenJust (windows . action)
        )
      | (key   , scr ) <- zip "nei" [0..]
      , (action, mask) <- [ (W.view, "") , (W.shift, "S-") ]
      ]
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    myWorkspacesKeybindings =
      [ (m <> wsKey, windows $ f ws)
      | (ws, wsKey ) <- zip myWorkspaces $ map show [1..9 :: Int]
      , (f , m     ) <- [(W.greedyView, "M"), (W.shift, "M-S-")]
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
          " -e 'mv $f ~/screenshots/'"
    callGreenclip = spawn $
      "rofi -modi \"clipboard:greenclip print\" -show clipboard " <>
      "-run-command '{cmd}'"
    rofiRun = spawn $
      "rofi -width 300 -lines 5 -show run"
    rofiWindow = spawn $
      "rofi -width 50 -lines 11 -show window"

myKeysToDelete =
  [ "M-q"
  , "M-<Space>"
  , "M-S-<Space>"
  , "M-S-w"
  , "M-S-c"
  ]

lockScreen =
  spawn "~/.config/lock-screen"

data ScreenshotMode
  = SMWhole
  | SMWindow
  | SMRect

myExitXMonad =
  CP.confirmPrompt
    promptConfig "XMonad exit" $ io (Ex.exitWith Ex.ExitSuccess)

resetLayout =
  setLayout
  $ Layout
  $ XMonad.layoutHook myConfig

pushWinBackToTiling =
  withFocused $ windows . W.sink

setFullLayout =
  sendMessage
  $ JumpToLayout
  $ description Full

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
  ||| myMirroredLayout
  ||| myTabLayout
  ||| myColLayout
  ||| Full

myMirroredLayout =
  renamed [Replace "Mir"]
  $ Mirror myTiledLayout

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
  renamed [Replace "Tab"]
  $ T.tabbedBottom T.shrinkText
  $ T.def -- Tabs theme modified below
    { T.activeColor         = colourMainLight
    , T.inactiveColor       = colourDark
    , T.activeBorderColor   = colourMainDark
    , T.inactiveBorderColor = colourMainDark
    , T.activeTextColor     = colourWhite
    , T.inactiveTextColor   = colourGrey
    , T.fontName            = mkXftFontString 10
    }

mkXftFontString size =
  -- myFont is in xmonad.theme.hs file
  "xft:" <> myFont <> ":size=" <> show size <> ":antialias=true:hinting=true"

myColLayout =
  renamed [Replace "Col"]
  $ ThreeCol 1 (3/100) (1/3)

data ExitMenuPrompt
  = ExitMenuPrompt

instance XPrompt ExitMenuPrompt where
  showXPrompt _ = "Menu: (e)xit (l)ock (h)ibernate (s)uspend (r)eboot (S)hutdown"

exitMenuPrompt =
  PT.mkXPrompt
    ExitMenuPrompt
    promptConfig
    (PT.mkComplFunFromList promptConfig exitOptions)
    exitActionHandler
  where
    exitOptions =
      [ "e", "l", "h", "s", "r", "S" ]
    exitActionHandler action =
      case action of
        "e" -> io (Ex.exitWith Ex.ExitSuccess)
        "l" -> lockScreen
        "h" -> lockScreen *> spawn "systemctl hibernate"
        "s" -> lockScreen *> spawn "systemctl suspend"
        "r" -> spawn "systemctl reboot"
        "S" -> spawn "systemctl poweroff"
        _   -> pure ()

promptConfig =
  PT.def
    { PT.font                  = mkXftFontString 12
    , PT.bgColor               = colourDark
    , PT.fgColor               = colourWhite
    , PT.bgHLight              = colourMainLight
    , PT.fgHLight              = colourWhite
    , PT.borderColor           = colourMainLight
    , PT.promptBorderWidth     = 1
    , PT.position              = PT.Top
    , PT.height                = 30
    , PT.historySize           = 0
    , PT.autoComplete          = Just 0
    }

-- append xmonad.your_config.hs here
