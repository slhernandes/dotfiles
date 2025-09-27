import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.bar.modules

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: toplevel
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

      visible: true

      // PopupWindow {
      //   anchor.window: toplevel
      //   anchor.rect.x: toplevel.width / 2 - width / 2
      //   anchor.rect.y: toplevel.height + 4
      //   width: 500
      //   height: 500
      //   visible: false
      //   color: "blue"
      //   MouseArea {
      //     id: mouse
      //     width: parent.width
      //     height: parent.height
      //     hoverEnabled: true
      //   }
      //   Rectangle {
      //     // anchors.centerIn: parent
      //     color: "red"
      //     width: 10
      //     height: 10
      //     radius: 5
      //     x: mouse.mouseX
      //     y: mouse.mouseY
      //   }
      // }

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
        }
      }
    }
  }
}
