import Quickshell.Io
import Quickshell.Widgets
import QtQuick

import qs

MouseArea {
  id: root
  required property var modelData

  implicitWidth: iconImage.width + 8
  acceptedButtons: Qt.LeftButton
  IconImage {
    id: iconImage
    anchors.centerIn: parent
    source: {
      if (!root.modelData) {
        return `${Variables.configDir}/icons/unknown.png`;
      }
      return root.modelData?.icon;
    }
    implicitSize: Variables.iconSize
  }
  onClicked: function (event) {
    activateWindow.command = ["hyprctl", "dispatch", "focuswindow", `address:${root.modelData.address}`];
    activateWindow.running = true;
  }
  Process {
    id: activateWindow
    running: false
  }
}
