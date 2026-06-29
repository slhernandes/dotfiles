pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import qs

Scope {
  id: root
  PanelWindow {
    id: notifCentre
    property real notifCellWidth: 380
    property real notifCellHeight: 100
    property real notifWindowWidth: 400
    property real notifWindowHeight: 800
    property real gap: 8
    screen: {
      let screens = Quickshell.screens;
      for (const s of screens) {
        if (s.name === GlobalStates.monitorName) {
          return s;
        }
      }
      return Quickshell.screens[0];
    }

    color: "transparent"

    MouseArea {
      id: ncMouseArea
      anchors.fill: parent
      onClicked: function () {
        if (!ncBackground.contains(Qt.point(mouseX, mouseY - Variables.barHeight - 4))) {
          GlobalStates.currentOverlay = GlobalStates.Overlay.None;
        }
      }
    }

    Shortcut {
      sequence: "escape"
      onActivated: GlobalStates.currentOverlay = GlobalStates.Overlay.None
    }

    Shortcut {
      sequence: "Ctrl+n"
      onActivated: () => {
        notifList.incrementCurrentIndex();
      }
    }

    Shortcut {
      sequence: "Ctrl+p"
      onActivated: () => {
        notifList.decrementCurrentIndex();
      }
    }

    Shortcut {
      sequence: "Return"
      onActivated: () => {
        notifList.currentItem?.invokeAction();
      }
    }

    Shortcut {
      sequence: "Backspace"
      onActivated: () => {
        notifList.currentItem?.dismissThis();
      }
    }

    Shortcut {
      sequence: "Alt+Backspace"
      onActivated: () => {
        NotificationService.dismissAllNotif();
      }
    }

    anchors {
      top: true
      left: true
      bottom: true
      right: true
    }

    margins.top: -Variables.barHeight
    margins.right: 4

    visible: GlobalStates.currentOverlay === GlobalStates.Overlay.NotifCentre

    Rectangle {
      id: ncBackground
      color: Theme.inactiveElement
      border {
        width: 2
        color: Theme.activeBorder
      }
      anchors.top: parent.top
      anchors.topMargin: Variables.barHeight + 4
      anchors.right: parent.right
      radius: Variables.radius
      opacity: Variables.ncBgOpacity
      width: notifCentre.notifWindowWidth
      height: notifCentre.notifWindowHeight
      visible: true
    }

    Rectangle {
      id: notifWindow
      color: "transparent"
      anchors.fill: ncBackground
      anchors.margins: notifCentre.gap
      ColumnLayout {
        id: notifWindowColumn
        // anchors.centerIn: parent
        spacing: notifCentre.gap
        anchors.fill: parent
        RowLayout {
          id: titleRow
          Layout.fillWidth: true
          Rectangle {
            id: titleRect
            property real preferredHeight: titleText.height + 2 * notifCentre.gap
            Layout.preferredHeight: preferredHeight
            // Layout.preferredWidth: titleText.width + 8
            Layout.fillWidth: true
            radius: Variables.radius
            color: Theme.barBgColour
            opacity: Variables.barOpacity
            Rectangle {
              anchors.fill: parent
              anchors.margins: notifCentre.gap
              color: "transparent"
              Text {
                id: titleText
                text: "Notifications"
                color: Theme.ncTextColour
                font {
                  family: Variables.fontFamilyTextNC
                  pointSize: Variables.fontSizeLogo
                }
              }
            }
          }
          Rectangle {
            id: removeAllRect
            Layout.preferredHeight: titleRect.preferredHeight
            Layout.preferredWidth: titleRect.preferredHeight
            color: removeAllMouseArea.containsMouse ? Theme.activeElement : Theme.barBgColour
            opacity: Variables.barOpacity
            radius: Variables.radius
            Text {
              id: removeAllIcon
              anchors.centerIn: parent
              text: "\ue16c"
              // text: "\ue0b8"
              color: Theme.ncTextColour
              font {
                family: Variables.fontFamilyTextIcons
                pointSize: Variables.fontSizeLogo
              }
            }
            Behavior on color {
              ColorAnimation {
                duration: 200
              }
            }
            MouseArea {
              id: removeAllMouseArea
              hoverEnabled: true
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: () => {
                NotificationService.dismissAllNotif();
              }
            }
          }
        }
        Rectangle {
          id: notifCells
          Layout.fillHeight: true
          Layout.fillWidth: true
          color: "transparent"
          ListView {
            id: notifList
            clip: true
            // ScrollBar shenanigans (I don't know why it's 3, but it seems to be working????)
            width: parent.width + 3
            height: parent.height
            spacing: notifCentre.gap
            keyNavigationEnabled: true
            ScrollBar.vertical: ScrollBar {
              clip: false
              anchors.right: parent.right
              height: parent.height
              anchors.margins: {
                right: -2; // ScrollBar shenanigans
              }
              contentItem: Rectangle {
                implicitWidth: 4
                color: Theme.ncScrollBarColour
                radius: 9999
              }
            }
            model: NotificationService.ncList
            delegate: Rectangle {
              id: rootRect
              width: notifCentre.notifCellWidth
              height: notifCentre.notifCellHeight
              radius: Variables.radius
              border {
                width: ListView.isCurrentItem ? 2 : 0
                color: Theme.activeBorder
              }
              property real closeIconSize: 25
              required property var index
              required property var notif
              required property var metadata
              color: Theme.barBgColour
              function dismissThis() {
                NotificationService.dismissNotif(rootRect.metadata.id);
              }
              function invokeAction() {
                const actions = rootRect.notif.actions;
                if (actions.length > 0) {
                  GlobalStates.currentOverlay = GlobalStates.Overlay.None;
                  actions[0].invoke();
                } else {
                  NotificationService.dismissNotif(rootRect.metadata.id);
                }
              }
              MouseArea {
                id: rootRectMouseArea
                anchors.fill: parent
                hoverEnabled: true
                implicitHeight: rootRect.closeIconSize
                implicitWidth: rootRect.closeIconSize
                cursorShape: Qt.PointingHandCursor
                onClicked: () => notifList.currentIndex = rootRect.index
                onDoubleClicked: () => {
                  notifList.currentIndex = rootRect.index;
                  rootRect.invokeAction();
                }
              }
              RowLayout {
                spacing: notifCentre.gap
                anchors.margins: notifCentre.gap
                anchors.fill: parent
                Rectangle {
                  Layout.preferredHeight: parent.height
                  Layout.preferredWidth: parent.height
                  color: "transparent"
                  IconImage {
                    // implicitSize: parent.height
                    anchors.centerIn: parent
                    anchors.fill: parent
                    anchors.margins: notifCentre.gap
                    source: {
                      const notif = rootRect.notif;
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
                }
                ColumnLayout {
                  Layout.fillWidth: true
                  Layout.fillHeight: true
                  spacing: notifCentre.gap / 2
                  Text {
                    id: appNameText
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    font {
                      family: Variables.fontFamilyTextCC
                      pointSize: Variables.fontSizeText
                      weight: Font.Bold
                    }
                    color: rootRect.metadata.urgency === NotificationUrgency.Critical ? Theme.notifTextCritical : Theme.notifTextNormal
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    text: rootRect.notif.appName
                  }
                  Text {
                    id: summaryText
                    Layout.fillWidth: true
                    font {
                      family: Variables.fontFamilyTextCC
                      pointSize: Variables.fontSizeText
                    }
                    color: rootRect.metadata.urgency === NotificationUrgency.Critical ? Theme.notifTextCritical : Theme.notifTextNormal
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    text: rootRect.notif?.summary
                  }
                  Text {
                    id: bodyText
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    font {
                      family: Variables.fontFamilyTextCC
                      pointSize: Variables.fontSizeText
                    }
                    color: rootRect.metadata.urgency === NotificationUrgency.Critical ? Theme.notifTextCritical : Theme.notifTextNormal
                    maximumLineCount: 1
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    text: rootRect.notif.body
                  }
                }
              }
              MouseArea {
                id: notifMouseArea
                anchors {
                  margins: notifCentre.gap
                  top: parent.top
                  right: parent.right
                }
                preventStealing: true
                hoverEnabled: true
                implicitHeight: rootRect.closeIconSize
                implicitWidth: rootRect.closeIconSize
                cursorShape: Qt.PointingHandCursor
                onClicked: function (event) {
                  NotificationService.dismissNotif(rootRect.metadata.id);
                }
              }
              Rectangle {
                anchors.fill: notifMouseArea
                implicitHeight: rootRect.closeIconSize
                implicitWidth: rootRect.closeIconSize
                radius: 100
                color: notifMouseArea.containsMouse ? Theme.activeElement : Theme.barBgColour
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
          }
        }
      }
    }

    Component.onCompleted: {
      this.WlrLayershell.layer = WlrLayer.Overlay;
      this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
      this.WlrLayershell.namespace = "qsNotifCentre";
    }
  }
}
