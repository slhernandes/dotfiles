pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property string configDir: "/home/samuelhernandes/.config/quickshell"

  property string fontFamilyText: "Noto Sans Mono"
  property string fontFamilyTextCC: "Noto Sans CJK"
  // property string fontFamilyText: "FiraCode Nerd Font Mono"
  property real fontSizeLogo: 18
  property real fontSizeText: 13
  property real fontSizeSmall: 9.5

  property real fontSizeIcon: 15.8
  property real iconSize: 16

  property real barHeight: 32
  property real ccBgOpacity: 0.5
  property real barOpacity: 0.85
  property int borderWidth: 2
  property int radius: 5

  property real fontSizeTooltip: 10
  property real paddingTooltip: 6
}
