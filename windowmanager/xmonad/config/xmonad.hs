  -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import Control.Monad ( join, when )
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust, maybeToList)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docks, docksEventHook, manageDocks, Direction2D(D, L, R, U) , ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.Gaps
    ( Direction2D(D, L, R, U),
      gaps,
      setGaps,
      GapMessage(DecGap, ToggleGaps, IncGap) )
import XMonad.Layout.Fullscreen
    ( fullscreenEventHook, fullscreenManageHook, fullscreenSupport, fullscreenFull )
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.Spacing ( spacingRaw, Border(Border) )
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce


import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

myFont :: String
myFont = "xft:Monoid Nerd Font Mono:regular:size=11:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "terminal"    -- Sets default terminal

myBrowser :: String
myBrowser = "qutebrowser "  -- Sets qutebrowser as browser

myBorderWidth :: Dimension
myBorderWidth = 1           -- Sets border width for windows

myNormColor :: String
myNormColor   = "#3b4261"   -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#59f0ff"   -- Border color of focused windows

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

-- Center and float a window (retain size)
centerFloat win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "lxqt-policykit-agent &"
    -- spawnOnce "xfce4-power-manager &"
    spawnOnce "autorandr --current"
    spawnOnce "greenclip daemon &"
    spawnOnce "picom -CG --experimental-backends &"
    spawnOnce "nm-applet &"
    spawnOnce "dropbox &"
    spawnOnce "/opt/enpass/Enpass -minimize &"
    spawnOnce "udiskie -ans -f /usr/bin/pcmanfm &"
    spawnOnce "onedrive -m &"
    spawnOnce "start_screensaver"
    spawnOnce "syndaemon -i 1 dkR &"
    spawnOnce "xset dpms 900 900 900"
    spawnOnce "remaps"
    spawnOnce "xbanish &"
    spawnOnce "/home/mgondermann/.xmonad/polybar/up"
    spawnOnce "/home/mgondermann/.xmonad/set_bg"
    setWMName "LG3D"

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 5
           $ ResizableTall 1 (3/100) (1/2) []
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Monoid Nerd Font Mono:regular:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#192330"
    , swn_color             = "#cdcecf"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 -- ||| noBorders monocle
                                 ||| floats
                                 -- ||| noBorders tabs
                                 -- ||| grid
                                 -- ||| spirals

myManageHook = fullscreenManageHook <+> manageDocks <+> composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , className =? "qjackctl"        --> doFloat
     , className =? "QjackCtl"        --> doFloat
     , className =? "zoom"            --> doFloat
     , className =? "Yad"             --> doCenterFloat
     , className =? "Peek"            --> doFloat
     , title =? "Oracle VM VirtualBox Manager"  --> doFloat
     , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "brave-browser"   --> doShift ( myWorkspaces !! 1 )
     , className =? "qutebrowser"     --> doShift ( myWorkspaces !! 1 )
     , className =? "mpv"             --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"            --> doShift ( myWorkspaces !! 8 )
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     , isFullscreen -->  doFullFloat
     ]

-- START_KEYS
myKeys :: [(String, X ())]
myKeys =
    -- KB_GROUP Xmonad
        [ ("M-C-r", spawn "xmonad --recompile &&xmonad --restart")  -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")    -- Restarts xmonad
        , ("M-S-q", io exitSuccess)              -- Quits xmonad
        , ("M-S-s", spawn "toggle_screensaver")  -- toggles screensaver on an off

    -- KB_GROUP Run Prompt
        , ("M-S-<Return>", spawn "launcher")
        , ("M-S-a", spawn "greenclip_launcher")

    -- KB_GROUP Other Dmenu Prompts
    -- In Xmonad and many tiling window managers, M-p is the default keybinding to
    -- launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
        , ("M-S-x", spawn "xmonadexit")    -- logout menu

    -- KB_GROUP Useful programs to have a keybinding for launch
        , ("M-<Return>", spawn (myTerminal))
        , ("M-w", spawn (myBrowser))

    -- KB_GROUP Kill windows
        , ("M-S-c", kill1)     -- Kill the currently focused client
        -- , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- KB_GROUP Workspaces
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-S-.", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-,", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- KB_GROUP Floating windows
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-f", withFocused centerFloat)  -- Make focused window float
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- KB_GROUP Grid Select (CTR-g followed by a key)
        , ("M1-<Tab>", spawn "rofi -no-lazy-grab -show window -modi window -theme $HOME/.xmonad/rofi/list_launcher.rasi -drun-icon-theme \"candy-icons\" ")

    -- KB_GROUP Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-<Left>", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-<Right>", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-<Left>", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-S-<Right>", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- KB_GROUP Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

    -- KB_GROUP Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane

    -- KB_GROUP Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- KB_GROUP Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        , ("M-C-h", sendMessage $ pullGroup L)
        , ("M-C-l", sendMessage $ pullGroup R)
        , ("M-C-k", sendMessage $ pullGroup U)
        , ("M-C-j", sendMessage $ pullGroup D)
        , ("M-C-m", withFocused (sendMessage . MergeAll))
        -- , ("M-C-u", withFocused (sendMessage . UnMerge))
        , ("M-C-/", withFocused (sendMessage . UnMergeAll))
        , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
        , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab

    -- wallpapers directory; then in sxiv, type 'C-x x' to set the wallpaper that you
    -- KB_GROUP Controls for mocp music player (SUPER-u followed by a key)
        , ("M-u p", spawn "mocp --play")
        , ("M-u l", spawn "mocp --next")
        , ("M-u h", spawn "mocp --previous")
        , ("M-u <Space>", spawn "mocp --toggle-pause")

    -- KB_GROUP Multimedia Keys
        , ("<XF86AudioPlay>", spawn "mocp --play")
        , ("<XF86AudioPrev>", spawn "mocp --previous")
        , ("<XF86AudioNext>", spawn "mocp --next")
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
        ]
    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))
-- END_KEYS
main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    -- Launching three instances of xmobar on their monitors.
    -- xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.xmonad/xmobar/xmobarrc"
    -- xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.xmonad/xmobar/xmobarrc"
    -- xmproc2 <- spawnPipe "xmobar -x 2 $HOME/.xmonad/xmobar/xmobarrc"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ fullscreenSupport $ docks $ ewmh def
        { manageHook         = myManageHook
        , handleEventHook    = mempty
        -- , handleEventHook    = docksEventHook
                               -- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                               -- This works perfect on SINGLE monitor systems. On multi-monitor systems,
                               -- it adds a border around the window if screen does not have focus. So, my solution
                               -- is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
                               -- <+> fullscreenEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook >> addEWMHFullscreen
        , layoutHook         = smartBorders $ myLayoutHook
        -- , layoutHook         = smartBorders $ showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP (polybarLogHook dbus)
        } `additionalKeysP` myKeys

workspaceIcons :: [String]
workspaceIcons = ["\xf120", "\xf268", "\xf108", "\xf02d", "\xf16b", "\xf095", "\xf025", "\xf008", "\xf03e"]

workspaceNames :: [String]
workspaceNames = ["dev", "www", "sys", "doc", "vbox", "chat", "mus", "vid", "gfx"]

myWorkspaces :: [String]
myWorkspaces = workspaceIcons

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myXmobarLogHook xmproc0 xmproc1 xmproc2 = dynamicLogWithPP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = \x -> hPutStrLn xmproc0 x                          -- xmobar on monitor 1
                              >> hPutStrLn xmproc1 x                          -- xmobar on monitor 2
                              >> hPutStrLn xmproc2 x                          -- xmobar on monitor 3
              , ppCurrent = xmobarColor "#59f0ff" ""                          -- Current workspace
              , ppVisible = xmobarColor "#63cdcf" "" . clickable              -- Visible but not current workspace
              , ppHidden = xmobarColor "#718cd6" "" . clickable               -- Hidden workspaces
              , ppHiddenNoWindows = xmobarColor "#475072" ""  . clickable     -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor "#cdcecf" "" . shorten 60               -- Title of active window
              , ppSep =  "<fc=#526175> <fn=1>|</fn> </fc>"                    -- Separator character
              , ppUrgent = xmobarColor "#d6616b" "" . wrap "!" "!"            -- Urgent workspace
              , ppExtras  = [windowCount]                                     -- # of windows current workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++[t]                    -- order of things in xmobar
              }

-- Override the PP values as you would otherwise, adding colors etc depending
-- on  the statusbar used

bg = "#192330"
bg_t1 = "#DD192330"
cyan = "#59f0ff"
green = "#58cd8b"
blue = "#718cd6"
purple = "#9d79d6"
gray = "#475072"
red = "#d6616b"
light_gray = "#526175"
fg = "#cdcecf"

polybarLogHook :: D.Client -> PP
polybarLogHook dbus = def
    { ppOutput = dbusOutput dbus
    , ppCurrent =         polyBarButton' cyan bg
    , ppVisible =         polyBarButton green
    , ppHidden =          polyBarButton purple
    , ppHiddenNoWindows = polyBarButton gray
    , ppUrgent =          polyBarButton red
    , ppWsSep = ""
    , ppSep = polyBarFgColor light_gray " | "
    , ppTitle = shorten 40 . polyBarFgColor fg
    , ppOrder  = \(ws:l:t:ex) -> [ws,l]++[t]                    -- order of things in xmobar
    }

wrapPolyBarColorTag :: String -> String -> String -> String
wrapPolyBarColorTag tag color = wrap ("%{" ++ tag ++ color ++ "}") ("%{" ++ tag ++ "-}")

polyBarFgColor :: String -> String -> String
polyBarFgColor color = wrapPolyBarColorTag "F" color

polyBarBgColor :: String -> String -> String
polyBarBgColor color = wrapPolyBarColorTag "B" color

polyBarAnchor :: WorkspaceId -> String -> String
polyBarAnchor ws content = do
    let i = (fromJust $ M.lookup ws myWorkspaceIndices) - 1
    wrap ("%{A1:wmctrl -s " ++ show i ++":}") "%{A}" content

polyBarButton :: String -> WorkspaceId -> String
polyBarButton fg ws = do
    polyBarAnchor ws . (wrap "%{T1}" "") . (polyBarFgColor fg) . (wrap "  " "  ") $ ws

polyBarButton' :: String -> String -> WorkspaceId -> String
polyBarButton' bg fg ws = do
    polyBarAnchor ws . wrap "%{T1}" "" . polyBarBgColor bg . polyBarFgColor fg . wrap "  " "  " $ ws

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"
