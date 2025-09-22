import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      color: "transparent"

      anchors {
        top: true
        left: true
        right: true
      }

      margins {
        top: 4
        left: 4
        right: 4
      }

      implicitHeight: 32

      // Rectangle {
      //     id: highlight
      //     anchors.fill: parent
      //     color: "#24273a"
      // }

      visible: true

      RowLayout {
        id: allBlocks
        spacing: 0
        RowLayout {
          id: leftBlocks
          spacing: 4
          Layout.alignment: Qt.AlignLeft
          Layout.fillWidth: true

          Logo {}
          Workspaces {}
        }
      }
    }
  }
}
