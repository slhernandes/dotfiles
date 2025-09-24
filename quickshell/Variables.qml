pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property string configDir: "/home/samuelhernandes/.config/quickshell"

  property string fontFamilyText: "Noto Sans Mono"
  // property string fontFamilyText: "FiraCode Nerd Font Mono"
  property real fontSizeIcon: 15.8
  property real fontSizeLogo: 18
  property real fontSizeText: 13
}
