pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property string terminal: Quickshell.env("TERMINAL") || "xterm"
  property string pdfReader: Quickshell.env("PDFREADER") || "xdg-open"
  property string browser: Quickshell.env("BROWSER") || "xdg-open"

  property string configDir: Quickshell.shellDir
  property string wallDir: Quickshell.env("XDG_CONFIG_HOME") + "/hypr/wallpapers"

  property string fontFamilyText: "Noto Sans Mono"
  property string fontFamilyTextCC: "Noto Sans CJK"
  property string fontFamilyTextNC: "Noto Sans CJK"
  property string fontFamilyTextIcons: "Material Symbols Sharp"
  property string fontFamilyLogo: "FiraCode Nerd Font Mono"
  property string fontFamilyWorkspaceIcon: "FiraCode Nerd Font Mono"

  property real fontSizeLogo: 18
  property real fontSizeWorkspaceIcon: 18
  property real fontSizeText: 13
  property real fontSizeSmall: 9.5

  property real fontSizeIcon: 15.8
  property real fontSizeIconL: 30
  property real iconSize: 16
  property real iconSizeBig: 22.5

  property real barHeight: 32
  property real ccBgOpacity: 0.5
  property real ncBgOpacity: 0.5
  property real barOpacity: 0.85
  property int borderWidth: 2
  property int radius: 5

  property real fontSizeTooltip: 10
  property real paddingTooltip: 6
  property real progressBarPadding: 8
}
