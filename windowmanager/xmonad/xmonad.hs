  -- Base
import XMonad
import Control.Monad
import Control.Applicative
import Control.Monad.Writer
import System.IO
import System.Exit (exitSuccess)
import Graphics.X11.Xinerama
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, shiftNextScreen, prevScreen, shiftPrevScreen)
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.List
import Data.Monoid
import Data.Maybe
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)

   -- Utilities
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont = "xft:Monoid NF:size=12:antialias=true:hinting=true"
myTerminal = "alacritty"   -- Sets default terminal
myBrowser = "qutebrowser "               -- Sets qutebrowser as browser for tree select
myEditor = myTerminal ++ " -e nvim "    -- Sets vim as editor for tree select
myLauncher = "rofi -matching fuzzy -show drun"

myModMask = mod4Mask       -- Sets modkey to super/windows key
altMask = mod1Mask         -- Setting this for use in xprompts

myBorderWidth = 1          -- Sets border width for windows
myNormColor   = "#4c566a"  -- Border color of normal windows
myFocusColor  = "#5e81ac"  -- Border color of focused windows

myStartupHook :: X ()
myStartupHook = do
          spawnOnce "~/.xmonad/autostart.sh"
          setWMName "LG3D"

myXPConfig :: XPConfig
myXPConfig = def
      { font                = myFont
      , bgColor             = "#2e3440"
      , fgColor             = "#d8dee9"
      , bgHLight            = "#88c0d0"
      , fgHLight            = "#2e3440"
      , borderColor         = "#4c566A"
      , promptBorderWidth   = 1
      , promptKeymap        = myXPKeymap
      , position            = Top
     -- , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 25
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      -- , searchPredicate     = isPrefixOf
      , searchPredicate     = fuzzyMatch
      , defaultPrompter     = id $ map toUpper  -- change prompt to UPPER
      -- , defaultPrompter     = unwords . map reverse . words  -- reverse the prompt
      -- , defaultPrompter     = drop 5 .id (++ "XXXX: ")  -- drop first 5 chars of prompt and add XXXX:
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to 'Just 5' for 5 rows
      }

myXPKeymap:: M.Map (KeyMask,KeySym) (XP ())
myXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line forwards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "ncmpcpp" spawnMusicPlayer findMusicPlayer manageMusicPlayer
                , NS "ytmusic" spawnYTMusic findYTMusic manageYTMusic
                ]
  where
    spawnTerm  = myTerminal ++ " --class scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMusicPlayer  = myTerminal ++ " --class ncmpcpp -e 'ncmpcpp'"
    findMusicPlayer   = resource =? "ncmpcpp"
    manageMusicPlayer = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnYTMusic = "chromium --app=https://music.youtube.com/library/uploaded_albums"
    findYTMusic = resource =? "music.youtube.com__library_uploaded_albums"
    manageYTMusic = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ smartBorders
           $ subLayout [] Simplest
           $ limitWindows 12
           -- $ layoutHintsWithPlacement (1.0, 0.0)
           $ (mySpacing' 4)
           $ ResizableTall 1 (1/20) (2/3) []
monocle  = renamed [Replace "monocle"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ noBorders
           $ subLayout [] Simplest
           $ limitWindows 20 Full
grid     = renamed [Replace "grid"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] Simplest
           $ smartBorders
           $ limitWindows 12
           $ mySpacing' 4
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme

myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout = tall
                                 ||| noBorders monocle
                                 ||| noBorders tabs
                                 ||| grid

-----------------------------------------------------------------------------}}}
-- Workspaces                                                                {{{
--------------------------------------------------------------------------------

wsGen = "\x1f5a5"
wsGenA = "\xf26c"
wsWeb = "\x1f30D"
wsWebA = "\xf0ac"
wsWrite = "\x1f58c"
wsWriteA = "\xf305"
wsDoc = "\x1f4c2"
wsDocA = "\xf07c"
wsBox = "\x1f4e6"
wsBoxA = "\xf49e"
wsCom = "\x1f4ac"
wsComA = "\xf4ad"
wsAudio = "\x1f3b9"
wsAudioA = "\xf3c9"
wsVideo = "\x1f37f"
wsVideoA = "\xf03d"
wsGraphics = "\x1f5bc"
wsGraphicsA = "\xf302"

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
    doubleLts '<' = "<<"
    doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
               $ [wsGenA, wsWebA, wsWriteA, wsDocA, wsBoxA, wsComA, wsAudioA, wsVideoA, wsGraphicsA]
               -- $ [wsGen, wsWeb, wsWrite, wsDoc, wsBox, wsCom, wsAudio, wsVideo, wsGraphics]
  where
    clickable l = [ "<action=xdotool key super+" ++ show(n) ++ "><fn=4>" ++ ws ++ "</fn></action>" |
                  (i,ws) <- zip [1..9] l,
                  let n = i ]

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces, and the names would very long if using clickable workspaces.
     [ title =? "Mozilla Firefox"             --> doShift ( myWorkspaces !! 1 )
     , className =? "qutebrowser"             --> viewShift ( myWorkspaces !! 1 )
     , className =? "sonic-pi"                --> doShift ( myWorkspaces !! 6 )
     , className =? "mpv"                     --> viewShift ( myWorkspaces !! 7 )
     , className =? "vlc"                     --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"                    --> doShift ( myWorkspaces !! 8 )
     , className =? "Gimp"                    --> doFloat
     , className =? "QjackCtl"                --> doFloat
     , className =? "xfreerdp"                --> doFullFloat
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     ] <+> namedScratchpadManageHook myScratchPads
       where viewShift = doF .liftM2 (.) W.greedyView W.shift

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.8

myKeys c =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile") -- Recompiles xmonad
        , ("M-r", spawn "xmonad --restart")   -- Restarts xmonad
        , ("M-S-r", spawn "xmonad --recompile && xmonad --restart")   -- Restarts xmonad
    --    , ("M-S-x", io exitSuccess)             -- Quits xmonad
        , ("M-S-x", spawn "xmonadexit")           -- shows exit prompt
        , ("M-M1-p", spawn "/opt/enpass/Enpass showassistant")

    -- Run Prompt
        , ("M-S-<Return>", spawn myLauncher) -- Shell Prompt

    -- Useful programs to have a keybinding for launch
        , ("M-<Return>", spawn myTerminal)
        , ("M-w", spawn myBrowser)
        , ("M-s", spawn "toggle_screensaver")
        , ("M-<F12>", spawn "touchpad_toggle")

    -- Kill windows
        , ("M-S-c", kill1)                         -- Kill the currently focused client

    -- Workspaces
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-S-.", shiftNextScreen >> nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Move window to prev monitor
        , ("M-S-,", shiftPrevScreen >> prevScreen)  -- Move window to prev monitor
        , ("M-S-+", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S--", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Increase/decrease spacing (gaps)
        , ("M-d", decWindowSpacing 4)           -- Decrease window spacing
        , ("M-i", incWindowSpacing 4)           -- Increase window spacing
        , ("M-S-d", decScreenSpacing 4)         -- Decrease screen spacing
        , ("M-S-i", incScreenSpacing 4)         -- Increase screen spacing

    -- Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-<Down>", windows W.focusDown)    -- Move focus to the next window
        , ("M-<Right>", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-<Up>", windows W.focusUp)      -- Move focus to the prev window
        , ("M-<Left>", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-S-<Space>", sendMessage ToggleStruts)     -- Toggles struts
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)  -- Toggles noborder

    -- Increase/decrease windows in the master pane or the stack
        , ("M-M1-<Up>", sendMessage (IncMasterN 1))      -- Increase number of clients in master pane
        , ("M-M1-<Down>", sendMessage (IncMasterN (-1))) -- Decrease number of clients in master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase number of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease number of windows

    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-S-<Left>", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-S-<Right>", sendMessage Expand)                   -- Expand horiz window width
        , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Exoand vert window width

    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        , ("M-C-h", sendMessage $ pullGroup L)
        , ("M-C-l", sendMessage $ pullGroup R)
        , ("M-C-k", sendMessage $ pullGroup U)
        , ("M-C-j", sendMessage $ pullGroup D)
        , ("M-C-m", withFocused (sendMessage . MergeAll))
        , ("M-C-u", withFocused (sendMessage . UnMerge))
        , ("M-C--", withFocused (sendMessage . UnMergeAll))
        , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
        , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab

    -- Scratchpads
        , ("M-M1-<Return>", namedScratchpadAction myScratchPads "terminal")
        , ("M1-S-m", namedScratchpadAction myScratchPads "ncmpcpp")
        , ("M-M1-m", namedScratchpadAction myScratchPads "ytmusic")

    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn (myTerminal ++ "mocp --play"))
        , ("<XF86AudioPrev>", spawn (myTerminal ++ "mocp --previous"))
        , ("<XF86AudioNext>", spawn (myTerminal ++ "mocp --next"))
        , ("<XF86AudioMute>",   spawn "lmc mute")  -- Bug prevents it from toggling correctly in 12.04.
        , ("<XF86AudioLowerVolume>", spawn "lmc down")
        , ("<XF86AudioRaiseVolume>", spawn "lmc up")
        ]
    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

--- Support for per-screen xmobars ---
getScreens :: IO [Int]
getScreens = openDisplay "" >>= liftA2 (<*) f closeDisplay
  where f = fmap (zipWith const [0..]) . getScreenInfo

multiPP :: PP       -- ^ The PP to use if the screen is focused
        -> PP       -- ^ The PP to use otherwise
        -> [Handle] -- ^ Handles for the status bars, in order of increasing X screen number
        -> X ()
multiPP = multiPP' dynamicLogString

multiPP' :: (PP -> X String) -> PP -> PP -> [Handle] -> X ()
multiPP' dynlStr focusPP unfocusPP handles = do
      state <- get
      let pickPP :: WorkspaceId -> WriterT (Last XState) X String
          pickPP ws = do
              let isFoc = (ws ==) . W.tag . W.workspace . W.current $ windowset state
              out <- lift $ dynlStr $ if isFoc then focusPP else unfocusPP
              when isFoc $ get >>= tell . Last . Just
              return out
      traverse put . getLast
          =<< execWriterT . (io . zipWithM_ hPutStrLn handles <=< mapM pickPP) . catMaybes
          =<< mapM screenWorkspace (zipWith const [0..] handles)
      return ()

mergePPOutputs :: [PP -> X String] -> PP -> X String
mergePPOutputs x pp = fmap (intercalate (ppSep pp)) . sequence . sequence x $ pp

onlyTitle :: PP -> PP
onlyTitle pp = defaultPP { ppCurrent = const ""
                         , ppHidden = const ""
                         , ppVisible = const ""
                         , ppLayout = ppLayout pp
                         , ppTitle = ppTitle pp }

xmobarScreen :: Int -> IO Handle
xmobarScreen n = spawnPipe ("xmobar -x " ++ show(n) ++ " ~/.xmonad/xmobar/xmobarrc" ++ show(n))

myPP :: PP
myPP = xmobarPP { ppCurrent = xmobarColor "#88c0d0" "" . wrap "<box type=VBoth color=#a3be8c width=2 mt=2 mb=3>" "</box>"              -- Current workspace in xmobar
                , ppVisible = xmobarColor "#81a1c1" "" . wrap "<box type=Bottom color=#a3be8c width=2 mt=2 mb=3>" "</box>"  -- Visible but not current workspace
                , ppHidden = xmobarColor "#d8dee9" "" . wrap "<box type=Bottom color=#82AAFF width=2 mt=2 mb=3>" "</box>"   -- Hidden workspaces in xmobar
                , ppHiddenNoWindows = xmobarColor "#4c566a" ""              -- Hidden workspaces (no windows)
                , ppSep =  " <fc=#666666><fn=1>|</fn></fc> "          -- Separators in xmobar
                , ppUrgent = xmobarColor "#d08770" "" . wrap "!" "!"  -- Urgent workspace
                , ppOrder  = \(ws:l:t:ex) -> [ws,l]
                }

-- basis config

myConfig hs = let c = defaultConfig {
      layoutHook         = myLayoutHook
    , focusFollowsMouse  = False
    , borderWidth        = myBorderWidth
    , focusedBorderColor = myFocusColor
    , normalBorderColor  = myNormColor
    , startupHook        = myStartupHook
    , terminal           = myTerminal
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    -- Run xmonad commands from command line with "xmonadctl command". Commands include:
    -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
    -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
    -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
    -- To compile xmonadctl: ghc -dynamic xmonadctl.hs
    , manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
    , logHook = do
          workspaceHistoryHook
          myLogHook
          multiPP'
              dynamicLogString
              myPP
              myPP { ppTitle = const "" }
              hs
          updatePointer (0.25, 0.25) (0.25, 0.25)
    , handleEventHook    = serverModeEventHookCmd
                           <+> serverModeEventHook
                           <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                           <+> docksEventHook
                           <+> fullscreenEventHook
    } in additionalKeysP c (myKeys c)
      `removeKeysP` [ "M-q", "M-S-q", "M-S-w", "M-e", "M-S-e" ] -- Remove leftover default keybindings

-- Start XMonad
main :: IO ()
main = do
    xmonad . ewmh . myConfig
      =<< mapM xmobarScreen =<< getScreens


