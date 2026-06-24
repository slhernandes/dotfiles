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
      screen: root.modelData
      WlrLayershell.namespace: "qsNotifications"
      WlrLayershell.layer: WlrLayer.Top
      WlrLayershell.exclusionMode: ExclusionMode.Ignore

      color: "transparent"
      readonly property int notifWidth: 380
      readonly property real borderMarginMult: 0.125
      readonly property real borderMarginMultV: 0.125
      readonly property real borderMarginMultH: 0.225

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
        spacing: 4
        width: notifWindow.notifWidth
        Repeater {
          id: notifRepeater
          model: root.notifModel

          delegate: MouseArea {
            id: rootRectMouseArea
            implicitWidth: rootRect.implicitWidth
            implicitHeight: rootRect.implicitHeight
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            required property var modelData
            onClicked: function (event) {
              const actions = modelData.notif?.actions;
              if (actions.length > 0) {
                actions[0].invoke();
              } else {
                NotificationService.deactivateNotifSignal();
              }
            }
            Timer {
              id: deactivateNotifTimer
              repeat: false
              running: false
              triggeredOnStart: false
              interval: 200
              onTriggered: () => {
                NotificationService.deactivateNotif(rootRectMouseArea.modelData.metadata.id);
              }
            }
            Rectangle {
              id: rootRect
              property var modelData: rootRectMouseArea.modelData
              property real closeIconSize: 25

              readonly property int notifHeightSingle: 110
              readonly property int notifHeightDouble: 130

              property int notifHeight: this.notifHeightDouble
              property int lineCount: 1
              OpacityAnimator on opacity {
                id: rootRectOpacityAnimator
                from: 1.0
                to: 0.0
                duration: 200
                running: false
              }

              Connections {
                target: NotificationService
                onDeactivateNotifSignal: () => {
                  rootRectOpacityAnimator.running = true;
                  deactivateNotifTimer.start();
                }
              }

              signal updateBodyLineCount
              implicitWidth: notifWindow.notifWidth
              implicitHeight: this.notifHeight
              anchors.centerIn: parent
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
                  margins: notifWindow.borderMarginMult * rootRect.notifHeightSingle
                  top: parent.top
                  right: parent.right
                }
                preventStealing: true
                hoverEnabled: true
                implicitHeight: rootRect.closeIconSize
                implicitWidth: rootRect.closeIconSize
                cursorShape: Qt.PointingHandCursor
                onClicked: function (event) {
                  NotificationService.deactivateNotifSignal();
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
                anchors.topMargin: notifWindow.borderMarginMultV * rootRect.notifHeightSingle
                anchors.bottomMargin: notifWindow.borderMarginMultV * rootRect.notifHeightSingle
                anchors.leftMargin: notifWindow.borderMarginMultH * rootRect.notifHeightSingle
                anchors.rightMargin: notifWindow.borderMarginMultH * rootRect.notifHeightSingle
                IconImage {
                  implicitSize: (0.5) * rootRect.notifHeightSingle
                  source: {
                    const notif = rootRect.modelData.notif;
                    const image = notif?.image;
                    const appIcon = notif?.appIcon;
                    if (!image && !appIcon) {
                      return "";
                    }
                    const imagePathComponent = image.split("/").slice(2);
                    const appIconPath = Quickshell.iconPath(`${appIcon}`, true);
                    let imagePath = "";
                    if (imagePathComponent[0] === "icon") {
                      imagePath = Quickshell.iconPath(imagePathComponent.slice(1).join("/"), true);
                    } else {
                      imagePath = image;
                    }
                    return imagePath || appIconPath || `file://${Variables.configDir}/icons/hakase_no_img.png`;
                  }
                }
                spacing: 12
                ColumnLayout {
                  id: notifColumn
                  spacing: 4
                  Text {
                    id: appNameText
                    Layout.fillWidth: true
                    font {
                      family: Variables.fontFamilyTextCC
                      pointSize: Variables.fontSizeText
                      weight: Font.Bold
                    }
                    color: rootRect.modelData.metadata.urgency === NotificationUrgency.Critical ? Theme.notifTextCritical : Theme.notifTextNormal
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    text: rootRect.modelData.notif?.appName
                  }
                  Text {
                    id: summaryText
                    Layout.fillWidth: true
                    font {
                      family: Variables.fontFamilyTextCC
                      pointSize: Variables.fontSizeText
                    }
                    color: rootRect.modelData.metadata.urgency === NotificationUrgency.Critical ? Theme.notifTextCritical : Theme.notifTextNormal
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    text: rootRect.modelData.notif?.summary
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
                    maximumLineCount: 2
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    text: rootRect.modelData.notif?.body
                    Component.onCompleted: () => {
                      rootRect.lineCount = this.lineCount;
                      rootRect.updateBodyLineCount();
                    }
                  }
                }
              }
              onUpdateBodyLineCount: () => {
                this.notifHeight = this.lineCount === 1 ? this.notifHeightSingle : this.notifHeightDouble;
              }
              Component.onCompleted: () => {
                console.log(JSON.stringify(this.modelData.notif));
              }
            }
          }
        }
      }
    }
  }
}
