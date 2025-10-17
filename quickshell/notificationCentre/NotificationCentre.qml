import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Notifications

import qs
import qs.notificationCentre

Scope {
  id: root

  LazyLoader {
    active: true
    PanelWindow {
      id: panel
      anchors {
        top: true
        right: true
        bottom: true
        left: true
      }
      margins.top: -Variables.barHeight
      margins.right: 4
      exclusiveZone: 0

      color: "transparent"
      visible: true

      // mask: Region {}
      Rectangle {
        id: ncBackground
        anchors {
          top: parent.top
          right: parent.right
        }
        anchors.topMargin: Variables.barHeight + 4
        color: Theme.barBgColour
        border {
          width: 2
          color: Theme.borderColour
        }
        opacity: Variables.barOpacity
        width: 340
        height: parent.height - Variables.barHeight - 8
        radius: Variables.radius

        ColumnLayout {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.topMargin: 8
          anchors.leftMargin: 8
          Rectangle {
            id: dismissButton
            implicitWidth: dismissAllText.width + dismissAllIcon.implicitSize + 8
            implicitHeight: dismissAllText.height + 4
            radius: Variables.radius
            color: Theme.inactiveElement
            RowLayout {
              id: dismissLayout
              anchors.centerIn: parent
              IconImage {
                id: dismissAllIcon
                implicitSize: dismissAllText.height
                source: `file://${Variables.configDir}/icons/close.png`
              }
              Text {
                id: dismissAllText
                Layout.alignment: Qt.AlignVCenter
                text: "delete all"
                font.family: Variables.fontFamilyTextCC
                font.pixelSize: Variables.fontSizeText
                color: Theme.ccTextColour
              }
            }
            MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.LeftButton
              hoverEnabled: true
              onEntered: () => {
                dismissButton.color = Theme.activeElement;
              }
              onExited: () => {
                dismissButton.color = Theme.inactiveElement;
              }
            }
            Behavior on color {
              ColorAnimation {
                duration: 200
              }
            }
          }
        }
      }

      MouseArea {
        id: ncMouseArea
        anchors.fill: parent
        onClicked: function () {
          if (!ncBackground.contains(Qt.point(mouseX - panel.width + ncBackground.width, mouseY - Variables.barHeight - 4))) {
            panel.visible = false;
          }
        }
      }

      Component.onCompleted: {
        this.WlrLayershell.layer = WlrLayer.Overlay;
        this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
        this.WlrLayershell.namespace = "qsNotificationCentre";
      }
    }
  }
}
