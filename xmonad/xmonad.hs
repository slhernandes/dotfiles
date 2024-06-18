-- my xmonad config
import Data.Char
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import Data.List
import qualified Data.Map as M

import XMonad

import XMonad.Actions.CycleWS

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
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral as Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

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
    , layoutHook         = layoutToggle
    , manageHook         = myManageHook <+> namedScratchpadManageHook scratchpads
    , startupHook        = myStartupHook >> myExclusives
    , workspaces         = myWorkspaces
    , focusedBorderColor = "#45e8ce"
    , normalBorderColor  = "#24283b"
    , terminal           = "kitty"
    , borderWidth        = 2
    }
  `additionalKeysP`
    [ ("M-S-z"   , spawn "xscreensaver-command -lock"                                     )
    , ("M-S-q"   , spawn "/home/samuelhernandes/.local/bin/sddmenu"                       )
    , ("M-d"     , spawn "/home/samuelhernandes/.local/bin/togglekeyboard"                )
    , ("M-p"     , spawn "rofi -show drun"                                                )
    , ("M-f"     , spawn "firefox -P default-release"                                     )
    , ("M-t"     , spawn "kitty -e tmux-start"                                            )
    , ("M-l"     , moveTo Next nonNSPEmpty                                                )
    , ("M-h"     , moveTo Prev nonNSPEmpty                                                )
    , ("M-S-l"   , shiftTo Next nonNSP >> moveTo Next nonNSP                              )
    , ("M-S-h"   , shiftTo Prev nonNSP >> moveTo Prev nonNSP                              )
  --, ("<XF86AudioLowerVolume>", spawn "wpctl set-volume @DEFAULT_SINK@ 2%-"              )
  --, ("<XF86AudioRaiseVolume>", spawn "wpctl set-volume @DEFAULT_SINK@ 2%+"              )
    , ("<XF86AudioRaiseVolume>", spawn "/home/samuelhernandes/.local/bin/volume.sh up"    )
    , ("<XF86AudioLowerVolume>", spawn "/home/samuelhernandes/.local/bin/volume.sh down"  )
    , ("<XF86AudioMute>"       , spawn "/home/samuelhernandes/.local/bin/volume.sh check" )
    , ("M-S-s"   , withFocused $ windows . W.sink                                         )
    , ("M-S-p"   , spawn "/home/samuelhernandes/.local/bin/find_pdf"                      )
    , ("M-s"     , spawn "xsnip"                                                          )
    , ("M-S-f"   , namedScratchpadAction scratchpads "Firefox"                            )
    , ("M-S-b"   , namedScratchpadAction scratchpads "Btop"                               )
    , ("M-S-m"   , namedScratchpadAction scratchpads "Mail"                               )
    , ("M-S-t"   , namedScratchpadAction scratchpads "Term"                               )
    , ("M-S-r"   , namedScratchpadAction scratchpads "Ranger"                             )
    , ("M-S-e"   , namedScratchpadAction scratchpads "EasyEffects"                        )
    ]
  `additionalKeys`
    [ ((0, xK_Print)        , spawn "xsnip -o"                                            )
    , ((mod4Mask, xK_Left)  , sendMessage Shrink                                          )
    , ((mod4Mask, xK_Right) , sendMessage Expand                                          )
    , ((0, xK_F7)           , spawn "/home/samuelhernandes/.local/bin/brightness.sh down" )
    , ((0, xK_F8)           , spawn "/home/samuelhernandes/.local/bin/brightness.sh up"   )
    , ((mod4Mask, xK_Return), sendMessage (MT.Toggle FULL) >> sendMessage ToggleStruts    )
    , ((mod4Mask, xK_Tab)   , spawn "rofi -show window"                                   )
    ]

myLayout = tiled ||| myTabbed ||| fullscreen
  where
    tiled             = spacing space $ Tall nmaster delta ratio
    mirror            = spacing space $ Mirror tiled
    myTabbed          = spacing space $ tabbed shrinkText myTabbedConfig
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
    fullscreen        = noBorders Full
    space             = 4
    borderWidthActive = 0
    borderWidth       = 1
    nmaster           = 1
    ratio             = 1/2
    delta             = 3/100
    blue              = "#2E3C64"
    lightBlue         = "#7AA2F7"
    green             = "#57F287"
    yellow            = "#F1FA8C" 
    white             = "#F8F8F2"
    red               = "#FF5555"
    fontTabbed        = "xft:Noto Sans Mono CJK JP:style=Regular:size=11"

layoutToggle = smartBorders $ mkToggle (NOBORDERS ?? FULL ?? EOT) myLayout

myWorkspaces :: [String]
myWorkspaces = [ "term"
               , "prog"
               , "dc:1"
               , "dc:2"
               , "br:1"
               , "br:2"
               , "stms"
               , "game"
               , "disc"
               ]

scratchpads = [ NS "Btop" "kitty --class=btop -e btop" (className =? "btop") myFloating
              , NS "EasyEffects" "easyeffects" (className =? "easyeffects") myFloating
              , NS "Firefox" "firefox --class firefox_scratch -P scratchpad" (className =? "firefox_scratch") myFloating
              , NS "Mail" "kitty --class=neomutt -e neomutt" (className =? "neomutt") myFloating
              , NS "Ranger" "kitty --class=ranger -e ranger" (className =? "ranger") myFloating
              , NS "Term" "kitty --class=scratchpad" (className =? "scratchpad") myFloating
              ]
              where
    myFloating  = customFloating $ W.RationalRect marginLeft marginTop width height
    marginLeft  = 1/6
    marginTop   = 5/216
    width       = 2/3
    height      = 2/3

myExclusives = addExclusives
  [ ["Btop"       , "Firefox"     ]
  , ["Btop"       , "Mail"        ]
  , ["Btop"       , "Ranger"      ]
  , ["Btop"       , "Term"        ]
  , ["Btop"       , "EasyEffects" ]
  , ["EasyEffects", "Firefox"     ]
  , ["EasyEffects", "Mail"        ]
  , ["EasyEffects", "Ranger"      ]
  , ["EasyEffects", "Term"        ]
  , ["Firefox"    , "Mail"        ]
  , ["Firefox"    , "Ranger"      ]
  , ["Firefox"    , "Term"        ]
  , ["Mail"       , "Ranger"      ]
  , ["Mail"       , "Term"        ]
  , ["Ranger"     , "Term"        ]
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
xpmPath x = "<icon=/home/samuelhernandes/.config/xmobar/xpms/" ++ x ++ "20.xpm/>"

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

firstCharAlpha :: String -> Query Bool
firstCharAlpha ""    = pure False
firstCharAlpha (x:_) = pure $ isLetter x

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
    , (className   =?  "discord")           <&&>
      (title       >>= firstCharAlpha)      --> doFloat
    , manageDocks
    ]

myStartupHook :: X ()
myStartupHook = do
  --spawnOnce "/usr/bin/prime-offload"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "amixer -c 2 sset 'Mic Boost',0 0"
  spawnOnce "feh --bg-fill --no-fehbg ~/Dokumente/custom_bg.png"
  spawnOnce "copyq &"
  spawnOnce "xscreensaver -nosplash &"
  spawnOnce "xfce4-power-manager &"
  spawnOnce "dunst &"
  spawnOnce "picom --config /home/samuelhernandes/.config/picom/picom.conf &"
  spawnOnce "/home/samuelhernandes/.local/bin/statusbar.sh"
  spawnOnce "if [ -x /usr/bin/nm-applet ] ; then nm-applet --sm-disable & fi"
  spawnOnce "xset r rate 150 50"
