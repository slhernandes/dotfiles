pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

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
              CCModuleBlock {
                implicitWidth: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
                implicitHeight: controlCentre.cellSize
                Item {}
              }
              CCModuleBlock {
                implicitWidth: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
                implicitHeight: controlCentre.cellSize * 2 + controlCentre.moduleGap
                ColumnLayout {
                  anchors.centerIn: parent
                  SystemClock {
                    id: clock
                    precision: SystemClock.Hours
                  }
                  Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: {
                      const locale = Qt.locale("de_DE");
                      const date = locale.toString(clock.date, "MMMM yyyy");
                      return date;
                    }
                  }
                  DayOfWeekRow {
                    locale: Qt.locale("de_DE")
                    Layout.fillWidth: true
                    implicitHeight: 20
                  }
                  MonthGrid {
                    id: monthGrid
                    Layout.fillWidth: true
                    delegate: Text {
                      required property var model
                      text: "    " + monthGrid.locale.toString(model.date, "d") + "    "
                      horizontalAlignment: Text.AlignHCenter
                      verticalAlignment: Text.AlignVCenter
                      font.pointSize: 9.5
                      color: {
                        if (model.month !== monthGrid.month) {
                          return "grey";
                        } else if (model.day === parseInt(Qt.formatDate(clock.date, "d"))) {
                          return "red";
                        }
                        return "black";
                      }
                    }
                  }
                }
              }
            }
            CCModuleBlock {
              implicitWidth: controlCentre.cellSize * 2 + controlCentre.moduleGap
              implicitHeight: controlCentre.cellSize * 4 + controlCentre.moduleGap * 3

              Item {}
            }
          }
          RowLayout {
            spacing: 8
            CCModuleBlock {
              implicitWidth: controlCentre.cellSize
              implicitHeight: controlCentre.cellSize
              Item {}
            }
            CCModuleBlock {
              implicitWidth: controlCentre.cellSize
              implicitHeight: controlCentre.cellSize
              Item {}
            }
            CCModuleBlock {
              implicitWidth: controlCentre.cellSize
              implicitHeight: controlCentre.cellSize
              Item {}
            }
            CCModuleBlock {
              implicitWidth: controlCentre.cellSize
              implicitHeight: controlCentre.cellSize
              Item {}
            }
            CCModuleBlock {
              implicitWidth: controlCentre.cellSize
              implicitHeight: controlCentre.cellSize
              Item {}
            }
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
