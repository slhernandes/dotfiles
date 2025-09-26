import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.bar.modules

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

      Rectangle {
        id: highlight
        anchors.fill: parent
        color: "transparent"
      }

      visible: true

      RowLayout {
        id: leftBlocks
        spacing: 4

        anchors {
          left: parent.left
          top: parent.top
        }

        LogoModule {}
        WorkspacesModule {}
      }
      RowLayout {
        id: centerBlocks
        spacing: 4

        anchors {
          top: parent.top
          horizontalCenter: parent.horizontalCenter
        }

        CurrentWindowModule {}
      }

      RowLayout {
        id: rightBlocks
        spacing: 4

        anchors {
          top: parent.top
          right: parent.right
        }

        UtilityModule {}
        InfoBlockModule {}
      }
      Component.onCompleted: {
        if (this.WlrLayershell != null) {
          this.WlrLayershell.layer = WlrLayer.Bottom;
        }
      }
    }
  }
}
