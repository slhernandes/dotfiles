pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs
import qs.controlCentre.widgets
import qs.controlCentre.modules

Scope {
  id: root
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: controlCentre
      required property var modelData
      property real cellSize: 100
      property real moduleGap: 8
      screen: modelData

      color: "transparent"

      MouseArea {
        id: ccMouseArea
        anchors.fill: parent
        onClicked: function () {
          if (!ccBackground.contains(Qt.point(mouseX, mouseY))) {
            GlobalStates.controlCentreVisible = false;
          }
        }
      }

      Shortcut {
        sequence: "escape"
        onActivated: GlobalStates.controlCentreVisible = false
      }

      anchors {
        top: true
        left: true
        bottom: true
        right: true
      }

      margins.top: 4
      margins.left: 4

      visible: GlobalStates.controlCentreVisible

      Rectangle {
        id: ccBackground
        color: Theme.inactiveElement
        radius: Variables.radius
        // border.width: Variables.borderWidth
        // border.color: Theme.borderColour
        opacity: Variables.ccBgOpacity
        width: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
        height: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
        visible: true
      }
      Rectangle {
        color: "transparent"
        width: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
        height: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
        ColumnLayout {
          id: controlCentreLayout
          anchors.centerIn: parent
          spacing: 8
          RowLayout {
            spacing: 8
            ColumnLayout {
              spacing: 8
              UserInfo {
                implicitWidth: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
                implicitHeight: controlCentre.cellSize
                cellSize: controlCentre.cellSize
                moduleGap: controlCentre.moduleGap
              }
              Weather {
                implicitWidth: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
                implicitHeight: controlCentre.cellSize
                cellSize: controlCentre.cellSize
                moduleGap: controlCentre.moduleGap
              }
              Calendar {
                implicitWidth: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
                implicitHeight: controlCentre.cellSize * 2 + controlCentre.moduleGap
                cellSize: controlCentre.cellSize
                moduleGap: controlCentre.moduleGap
              }
            }
            CCModuleBlock {
              implicitWidth: controlCentre.cellSize * 2 + controlCentre.moduleGap
              implicitHeight: controlCentre.cellSize * 4 + controlCentre.moduleGap * 3

              Item {}
            }
          }
          PowerMenu {
            implicitWidth: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4
            implicitHeight: controlCentre.cellSize
            cellSize: controlCentre.cellSize
            moduleGap: controlCentre.moduleGap
          }
        }
      }

      Component.onCompleted: {
        this.WlrLayershell.layer = WlrLayer.Overlay;
        this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
        this.WlrLayershell.namespace = "qsControlCentre";
      }
    }
  }
}
