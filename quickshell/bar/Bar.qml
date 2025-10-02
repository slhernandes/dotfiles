import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs
import qs.bar.modules

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
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

      implicitHeight: Variables.barHeight

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
        CurrentWorkspaceWindowsModule {}
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

        SystemTrayModule {}
        UtilityModule {}
        InfoBlockModule {}
      }
      Component.onCompleted: {
        if (this.WlrLayershell != null) {
          this.WlrLayershell.layer = WlrLayer.Bottom;
          this.WlrLayershell.namespace = "qsBar";
        }
      }
    }
  }
}
