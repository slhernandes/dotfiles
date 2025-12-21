pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Widgets
import qs

Variants {
  model: Quickshell.screens
  delegate: Loader {
    id: root
    required property ShellScreen modelData
    property ListModel notifModel: NotificationService.activeList
    active: notifModel.count > 0
    sourceComponent: PanelWindow {
      id: notifWindow
      screen: modelData
      WlrLayershell.namespace: "qsNotifications"
      WlrLayershell.layer: WlrLayer.Top
      WlrLayershell.exclusionMode: ExclusionMode.Ignore

      color: "transparent"
      readonly property int notifWidth: 400
      readonly property int notifHeight: 100
      anchors {
        top: true
        right: true
      }
      margins {
        top: Variables.barHeight + 8
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
        width: notifWindow.notifWidth
        Repeater {
          id: notificationRepeater
          model: root.notifModel
          delegate: Rectangle {
            id: rootRect
            required property var modelData
            property real closeIconSize: 25
            implicitWidth: notifWindow.notifWidth
            implicitHeight: notifWindow.notifHeight
            radius: Variables.radius
            color: modelData.metadata.urgency === NotificationUrgency.Critical ? Theme.notifCritical : Theme.notifNormal
            border {
              width: 2
              color: Theme.activeBorder
            }
            opacity: Variables.barOpacity

            MouseArea {
              id: notifMouseArea
              anchors {
                margins: 0.1 * rootRect.implicitHeight
                top: parent.top
                right: parent.right
              }
              hoverEnabled: true
              implicitHeight: rootRect.closeIconSize
              implicitWidth: rootRect.closeIconSize
              cursorShape: Qt.PointingHandCursor
              onClicked: function (event) {
                NotificationService.deactivateNotif(rootRect.modelData.metadata.id);
              }
              Rectangle {
                implicitHeight: rootRect.closeIconSize
                implicitWidth: rootRect.closeIconSize
                radius: 100
                color: notifMouseArea.containsMouse ? Theme.activeElement : Theme.inactiveElement
                Behavior on color {
                  ColorAnimation {
                    duration: 200
                  }
                }
                IconImage {
                  source: `file://${Variables.configDir}/icons/close.png`
                  implicitSize: rootRect.closeIconSize
                }
              }
            }
            RowLayout {
              id: notifRow
              anchors.fill: parent
              anchors.margins: 0.1 * rootRect.implicitHeight
              Layout.margins: 0.1 * rootRect.implicitHeight
              IconImage {
                implicitSize: 0.8 * rootRect.implicitHeight
                source: {
                  const image = rootRect.modelData.notif.image || rootRect.modelData.notif.appIcon || "";
                  return Quickshell.iconPath(image, true) || Quickshell.iconPath(`file://${image}`, true) || `file://${Variables.configDir}/icons/hakase_no_img.png`;
                }
              }
              spacing: 12
              ColumnLayout {
                id: notifColumn
                spacing: 4
                Text {
                  id: summaryText
                  Layout.fillWidth: true
                  font {
                    family: Variables.fontFamilyTextCC
                    pointSize: Variables.fontSizeIcon
                  }
                  color: rootRect.modelData.metadata.urgency === NotificationUrgency.Critical ? Theme.notifTextCritical : Theme.notifTextNormal
                  text: rootRect.modelData.notif.summary
                }
                Text {
                  id: bodyText
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  font {
                    family: Variables.fontFamilyTextCC
                    pointSize: Variables.fontSizeText
                  }
                  color: rootRect.modelData.metadata.urgency === NotificationUrgency.Critical ? Theme.notifTextCritical : Theme.notifTextNormal
                  text: rootRect.modelData.notif.body
                }
              }
            }
          }
        }
      }
    }
  }
}
