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
          if (!ccBackground.contains(Qt.point(mouseX, mouseY - Variables.barHeight - 4))) {
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

      margins.top: -Variables.barHeight
      margins.left: 4

      visible: GlobalStates.controlCentreVisible

      Rectangle {
        id: ccBackground
        color: Theme.inactiveElement
        anchors.top: parent.top
        anchors.topMargin: Variables.barHeight + 4
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
        anchors.top: parent.top
        anchors.topMargin: Variables.barHeight + 4
        width: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
        height: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
        ColumnLayout {
          id: controlCentreLayout
          anchors.centerIn: parent
          spacing: controlCentre.moduleGap
          RowLayout {
            spacing: controlCentre.moduleGap
            ColumnLayout {
              spacing: controlCentre.moduleGap
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
            ColumnLayout {
              spacing: controlCentre.moduleGap
              MediaPlayer {
                implicitWidth: controlCentre.cellSize * 2 + controlCentre.moduleGap
                implicitHeight: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
                cellSize: controlCentre.cellSize
                moduleGap: controlCentre.moduleGap
              }
              VolumeControl {
                implicitWidth: controlCentre.cellSize * 2 + controlCentre.moduleGap
                implicitHeight: controlCentre.cellSize
                cellSize: controlCentre.cellSize
                moduleGap: controlCentre.moduleGap
              }
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
