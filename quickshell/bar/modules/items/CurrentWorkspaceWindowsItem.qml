import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import qs.bar

MouseArea {
  id: root
  required property var modelData

  implicitWidth: iconImage.width + 8
  acceptedButtons: Qt.LeftButton
  IconImage {
    id: iconImage
    anchors.centerIn: parent
    source: {
      return root.modelData.icon;
    }
    implicitSize: 16
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

// IconImage {
//   id: iconImage
//   anchors.centerIn: parent
//   source: {
//     let icon = parent.item.icon;
//     if (icon.includes("?path=")) {
//       const [name, path] = icon.split("?path=");
//       icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
//     }
//     return icon;
//   }
//   implicitSize: 16
// }
