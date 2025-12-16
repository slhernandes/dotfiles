import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Widgets

Variants {
  model: Quickshell.screens
  delegate: Loader {
    id: root
    required property ShellScreen modelData
    property var notifModel: Object.values(NotificationService.activeNotif)
    active: notifModel.length > 0
    sourceComponent: PanelWindow {
      id: notifWindow
      screen: modelData
      WlrLayershell.namespace: "qsNotifications"
      WlrLayershell.layer: WlrLayer.Top
      WlrLayershell.exclusionMode: ExclusionMode.Ignore

      color: "transparent"
      readonly property int notifWidth: 400
      anchors {
        top: true
        right: true
      }
      margins {
        top: 4
        right: 4
      }
      implicitWidth: notifWidth
      implicitHeight: notifStack.implicitHeight
      ColumnLayout {
        id: notifStack
        // anchors {
        //   top: true
        //   right: true
        // }
        spacing: 4
        width: notifWidth
        Repeater {
          id: notificationRepeater
          model: notifModel
          delegate: Rectangle {
            implicitWidth: notifWidth
            implicitHeight: 100
          }
        }
      }
    }
  }
}
