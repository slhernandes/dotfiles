import Quickshell.Hyprland
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
