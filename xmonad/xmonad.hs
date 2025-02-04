-- my xmonad config
import Data.Char
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import Data.List
import qualified Data.Map as M

import System.Environment
import System.IO.Unsafe

import XMonad

import XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize as Flex
import XMonad.Actions.SpawnOn

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.ClickableWorkspaces
import qualified XMonad.Util.Hacks as Hacks
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce
import XMonad.Util.WorkspaceCompare

import XMonad.Layout.Dishes
import XMonad.Layout.MagicFocus
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle as MT
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral as Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

import XMonad.Prompt
import XMonad.Prompt.Pass

import qualified XMonad.StackSet as W

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myConfig = def
    { modMask            = mod4Mask
    , handleEventHook    = handleEventHook def <> Hacks.trayerAboveXmobarEventHook
    , layoutHook         = myLayoutHook
    , manageHook         = myManageHook <+> namedScratchpadManageHook scratchpads <> manageSpawn
    , startupHook        = myStartupHook >> myExclusives
    , workspaces         = myWorkspaces
    , focusedBorderColor = "#45e8ce"
    , normalBorderColor  = "#24283b"
    , terminal           = "kitty"
    , borderWidth        = 2
    }
  `additionalKeysP`
    [ ("M-S-z"   , spawn "xscreensaver-command -lock"                                     )
    , ("M-S-q"   , spawn "$HOME/.local/bin/sddmenu"                                       )
    , ("M-S-n"   , spawn "notificationcenter"                                             )
----, ("M-d"     , spawn "$HOME/.local/bin/togglekeyboard"                                )
    , ("M-p"     , spawn "rofi -show drun"                                                )
    , ("M-f"     , spawnOn "br:1" "firefox -P default-release"                            )
    , ("M-t"     , spawnOn "term" "kitty -e $HOME/.config/tmux/bin/tmux-start"            )
    , ("M-l"     , moveTo Next nonNSPEmpty                                                )
    , ("M-h"     , moveTo Prev nonNSPEmpty                                                )
    , ("M-S-l"   , shiftTo Next nonNSP >> moveTo Next nonNSP                              )
    , ("M-S-h"   , shiftTo Prev nonNSP >> moveTo Prev nonNSP                              )
----, ("<XF86AudioLowerVolume>", spawn "wpctl set-volume @DEFAULT_SINK@ 2%-"              )
----, ("<XF86AudioRaiseVolume>", spawn "wpctl set-volume @DEFAULT_SINK@ 2%+"              )
    , ("<XF86AudioRaiseVolume>", spawn "$HOME/.local/bin/volume up"                       )
    , ("<XF86AudioLowerVolume>", spawn "$HOME/.local/bin/volume down"                     )
    , ("<XF86AudioMute>"       , spawn "$HOME/.local/bin/volume mute"                     )
    , ("M-S-s"   , withFocused $ windows . W.sink                                         )
    , ("M-S-p"   , spawn "$HOME/.local/bin/find_pdf"                                      )
    , ("M-s"     , spawn "xsnip"                                                          )
    , ("M-S-b"   , namedScratchpadAction scratchpads "Btop"                               )
    , ("M-S-e"   , namedScratchpadAction scratchpads "EasyEffects"                        )
    , ("M-S-f"   , namedScratchpadAction scratchpads "Firefox"                            )
    , ("M-S-m"   , namedScratchpadAction scratchpads "Mail"                               )
    , ("M-S-r"   , namedScratchpadAction scratchpads "Ranger"                             )
    , ("M-S-t"   , namedScratchpadAction scratchpads "Term"                               )
    , ("M-S-y"   , namedScratchpadAction scratchpads "Ytermusic"                          )
    , ("M-c"     , passPrompt xpconfig                                                    )
    ]
  `additionalKeys`
    [ ((0, xK_Print)        , spawn "xsnip -o"                                            )
    , ((mod4Mask, xK_Left)  , sendMessage Shrink                                          )
    , ((mod4Mask, xK_Right) , sendMessage Expand                                          )
    , ((0, xK_F7)           , spawn "$HOME/.local/bin/brightness.sh down"                 )
    , ((0, xK_F8)           , spawn "$HOME/.local/bin/brightness.sh up"                   )
    , ((mod4Mask, xK_Return), sendMessage (MT.Toggle FULL) >> sendMessage ToggleStruts    )
    , ((mod4Mask, xK_Tab)   , spawn "rofi -show window"                                   )
    ]
  `additionalMouseBindings`
    [ ((mod4Mask, button3)  , (\w -> focus w >> (Flex.mouseResizeEdgeWindow (3/4) w))     )
    ]

xpconfig = def
    { font                = "xft:Noto Sans Mono CJK JP:style=Regular:size=11"
    , bgColor             = "#24283b" 
    , fgColor             = "#c0caf5"
    , bgHLight            = "#2e3c64"
    , fgHLight            = "#c0caf5"
    , borderColor         = "#7AA2F7"
    , promptBorderWidth   = 0
    , position            = pos
    , showCompletionOnTab = True
    }
    where
      pos = CenteredAt { xpCenterY = 1/2
                       , xpWidth   = 1/3
                       }

myWorkspaces :: [String]
myWorkspaces = [ "term"
               , "prog"
               , "dc:1"
               , "dc:2"
               , "br:1"
               , "br:2"
               , "stms"
               , "game"
               , "socs"
               ]

tiled = spacing space $ Tall nmaster delta ratio
  where
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100
    space   = 4

--mirror = spacing space $ Mirror tiled
--  where
--    space = 4

myTabbed = spacing space $ tabbed shrinkText myTabbedConfig
  where
    myTabbedConfig    = def { activeColor         = lightBlue
                            , inactiveColor       = blue
                            , urgentColor         = yellow
                            , activeBorderColor   = blue
                            , inactiveBorderColor = blue
                            , urgentBorderColor   = green
                            , activeBorderWidth   = borderWidthActive
                            , inactiveBorderWidth = borderWidth 
                            , urgentBorderWidth   = borderWidth 
                            , activeTextColor     = white
                            , inactiveTextColor   = white
                            , urgentTextColor     = red
                            , fontName            = fontTabbed
                            }
    space             = 4
    borderWidthActive = 0
    borderWidth       = 1
    blue              = "#2E3C64"
    lightBlue         = "#7AA2F7"
    green             = "#57F287"
    yellow            = "#F1FA8C" 
    white             = "#F8F8F2"
    red               = "#FF5555"
    fontTabbed        = "xft:Noto Sans Mono CJK JP:style=Regular:size=12"

fullscreen = noBorders Full

layoutNorm = tiled ||| myTabbed ||| fullscreen
layoutSocs = myTabbed ||| tiled ||| fullscreen

layoutToggleNorm = smartBorders $ mkToggle (NOBORDERS ?? FULL ?? EOT) layoutNorm
layoutToggleSocs = smartBorders $ mkToggle (NOBORDERS ?? FULL ?? EOT) layoutSocs

myLayoutHook = onWorkspace "socs" layoutToggleSocs $ layoutToggleNorm

scratchpads = [ NS "Btop"        "wezterm start --class=btop -e btop"            (className =? "btop")            myFloating
              , NS "EasyEffects" "easyeffects"                                   (className =? "easyeffects")     myFloating
              , NS "Firefox"     "firefox --class firefox_scratch -P scratchpad" (className =? "firefox_scratch") myFloating
              , NS "Mail"        "wezterm start --class=neomutt -e neomutt"      (className =? "neomutt")         myFloating
              , NS "Ranger"      "wezterm start --class=ranger -e ranger"        (className =? "ranger")          myFloating
              , NS "Term"        "wezterm start --class=scratchpad"              (className =? "scratchpad")      myFloating
              , NS "Ytermusic"   "wezterm start --class=ytermusic -e ytermusic"  (className =? "ytermusic")       myFloating
              ]
              where
    myFloating  = customFloating $ W.RationalRect marginLeft marginTop width height
    marginLeft  = 1/6
    marginTop   = 5/216
    width       = 2/3
    height      = 2/3

myExclusives = addExclusives
    [ ["Btop"       , "EasyEffects" ]
    , ["Btop"       , "Firefox"     ]
    , ["Btop"       , "Mail"        ]
    , ["Btop"       , "Ranger"      ]
    , ["Btop"       , "Term"        ]
    , ["Btop"       , "Ytermusic"   ]
    , ["EasyEffects", "Firefox"     ]
    , ["EasyEffects", "Mail"        ]
    , ["EasyEffects", "Ranger"      ]
    , ["EasyEffects", "Term"        ]
    , ["EasyEffects", "Ytermusic"   ]
    , ["Firefox"    , "Mail"        ]
    , ["Firefox"    , "Ranger"      ]
    , ["Firefox"    , "Term"        ]
    , ["Firefox"    , "Ytermusic"   ]
    , ["Mail"       , "Ranger"      ]
    , ["Mail"       , "Term"        ]
    , ["Mail"       , "Ytermusic"   ]
    , ["Ranger"     , "Term"        ]
    , ["Ranger"     , "Ytermusic"   ]
    , ["Term"       , "Ytermusic"   ]
    ]

nonNSP :: WSType
nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))

nonNSPEmpty :: WSType
nonNSPEmpty = WSIs (return (\ws -> W.tag ws /= "NSP")) :&: Not emptyWS

myXmobarPP :: PP
myXmobarPP = def
    --{ ppCurrent         = wrap "·" "" . xmobarBorder "Bottom" "#8be9fd" 2
    { ppCurrent         = xmobarBorder "Bottom" "#8be9fd" 2
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    , ppHiddenNoWindows = myPpHiddenNoWindow
    , ppHidden          = myPpHidden
    , ppLayout          = xmobarColor "#8be9fd" "" . myLayoutPrinter
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppSep             = green "·" -- ⍿
    , ppTitleSanitize   = xmobarStrip
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    }
  where
    formatFocused = wrap (white "") (green "·") . green . ppWindow
    formatUnfocused = wrap (lowWhite "") (green "·") . lowWhite . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 16
    green    = xmobarColor "#57f287" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#555555" ""

xpmPath :: String -> String
xpmPath x = "<icon=" ++ home ++ "/.config/xmobar/xpms/" ++ x ++ "20.xpm/>"
  where
    home = unsafePerformIO $ getEnv "HOME"

layoutAction :: String -> String
layoutAction x = "<action=`xdotool key super+space` button=1>" ++ x ++ "</action>"

getIndex :: [String] -> String -> Int
getIndex a s = helper a s 0
  where
    helper :: [String] -> String -> Int -> Int
    helper [] s n  = -1
    helper (a:r) s n = if a == s then n
                       else helper r s (n+1)

myLayoutPrinter :: String -> String
myLayoutPrinter "Full"                    = layoutAction $ xpmPath "full"
myLayoutPrinter "Spacing Tall"            = layoutAction $ xpmPath "tall"
myLayoutPrinter "Spacing Tabbed Simplest" = layoutAction $ xpmPath "tabbed"

myPpHiddenNoWindow :: WorkspaceId -> String
myPpHiddenNoWindow "NSP" = ""
myPpHiddenNoWindow x = clickableWrap idx $ xmobarColor "#555555" "" $ wrap "" "" x 
  where
    idx :: Int
    idx = getIndex myWorkspaces x

myPpHidden :: WorkspaceId -> String
myPpHidden "NSP" = ""
myPpHidden x = clickableWrap idx $ xmobarColor "#f8f8f2" "" $ wrap "" "" x 
  where
    idx :: Int
    idx = getIndex myWorkspaces x

suffixIsPopout :: String -> Query Bool
suffixIsPopout s = pure $ isSuffixOf "Popout" s

myManageHook :: ManageHook
myManageHook = composeAll
    [ isDialog                              --> doFloat
    , title        =?  "Picture-in-Picture" --> doFloat
    , className    =?  "Toolkit"            --> doFloat
    , className    =?  "Navigator"          --> doFloat
    , className    =?  "Places"             --> doFloat
    , title        =?  "Library"            --> doFloat
    , title        =?  "Friends List"       --> doFloat
    , isFullscreen                          --> doFullFloat
    , (className   =?  "vesktop")           <&&>
      (title       >>= suffixIsPopout)      --> doFloat
    , className    =?  "vesktop"            --> doShift "socs"
    , className    =?  "steam"              --> doShift "stms"
    , className    =?  "firefox"            --> doShift "br:1"
    , className    =?  "Ferdium"            --> doShift "socs"
    , manageDocks
    ]

myStartupHook :: X ()
myStartupHook = do
--spawnOnce "/usr/bin/prime-offload"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "amixer -c 2 sset 'Mic Boost',0 0"
  spawnOnce "feh --bg-fill --no-fehbg ~/.config/xmonad/wallpaper/custom_bg.png"
  spawnOnce "copyq &"
  spawnOnce "xscreensaver -nosplash &"
  spawnOnce "xfce4-power-manager &"
  spawnOnce "dunst &"
--spawnOnce "picom --config $HOME/.config/picom/picom.conf &"
  spawnOnce "$HOME/.local/bin/statusbar.sh"
  spawnOnce "if [ -x /usr/bin/nm-applet ] ; then nm-applet --sm-disable & fi"
  spawnOnce "xset r rate 150 50"
  spawnOnce "caffeine &"
  spawnOnce "fcitx5 &"
  spawnOnce "nat_scroll.sh"
