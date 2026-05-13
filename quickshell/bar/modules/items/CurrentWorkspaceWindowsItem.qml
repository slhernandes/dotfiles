import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick

import qs

MouseArea {
  id: root
  required property var modelData
  property string title: modelData.title

  width: iconImage.implicitSize + 8
  height: iconImage.implicitSize + 8
  acceptedButtons: Qt.LeftButton
  cursorShape: Qt.PointingHandCursor
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
    Hyprland.dispatch(`hl.dsp.focus({window = "address:${root.modelData.address}"})`);
  }
}
