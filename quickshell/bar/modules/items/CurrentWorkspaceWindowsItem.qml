import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick

import qs

MouseArea {
  id: root
  required property var modelData

  width: iconImage.implicitSize + 8
  height: iconImage.implicitSize + 8
  acceptedButtons: Qt.LeftButton
  IconImage {
    id: iconImage
    anchors.centerIn: parent
    source: {
      if (!root.modelData) {
        return `file://${Variables.configDir}/icons/unknown.png`;
      }
      return root.modelData?.icon;
    }
    implicitSize: Variables.iconSize
  }
  onClicked: function (event) {
    Hyprland.dispatch(`focuswindow address:${root.modelData.address}`);
  }
}
