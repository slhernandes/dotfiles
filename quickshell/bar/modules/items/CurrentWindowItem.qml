import QtQuick
import Quickshell.Hyprland

import qs
import qs.bar

Item {
  id: root
  width: Math.ceil(windowTitle.width)
  Text {
    id: windowTitle
    anchors.centerIn: parent
    font {
      pointSize: Variables.fontSizeText
      family: Variables.fontFamilyText
    }
    text: {
      let win_name = HyprlandUtils.currentActiveWindow;
      if (win_name.length > 20) {
        win_name = win_name.slice(0, 19) + "…";
      }
      return win_name;
    }
    color: Theme.windowTitleColour
  }
}
