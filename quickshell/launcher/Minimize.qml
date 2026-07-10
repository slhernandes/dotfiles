pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs

Scope {
  id: root
  PanelWindow {
    id: minimize
    property real monitorWidth: width
    property real monitorHeight: height + Variables.barHeight
    property real minimizeWidth: 0.5 * monitorWidth
    property real minimizeHeight: 0.26 * monitorHeight
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
      id: minimizeMouseArea
      anchors.fill: parent
      onClicked: function () {
        if (!ncBackground.contains(Qt.point(mouseX, mouseY - Variables.barHeight - 4))) {
          GlobalStates.currentOverlay = GlobalStates.Overlay.None;
        }
      }
    }

    Shortcut {
      sequence: "escape"
      onActivated: () => {
        GlobalStates.currentOverlay = GlobalStates.Overlay.None;
      }
    }

    Shortcut {
      sequence: "Ctrl+n"
      onActivated: () => {
        tlList.incrementCurrentIndex();
      }
    }

    Shortcut {
      sequence: "Ctrl+p"
      onActivated: () => {
        tlList.decrementCurrentIndex();
      }
    }

    Shortcut {
      sequence: "Return"
      onActivated: () => {
        const item = tlList.currentItem;
        if (!item) {
          return;
        }
        const address = item.address;
        const activeWs = Hyprland.focusedWorkspace;
        if (!activeWs) {
          return;
        }
        GlobalStates.currentOverlay = GlobalStates.Overlay.None;
        Hyprland.dispatch(`hl.dsp.window.move({workspace=${activeWs.id}, window="address:0x${address}"})`);
      }
    }

    anchors {
      top: true
      left: true
      bottom: true
      right: true
    }

    margins.top: -Variables.barHeight

    visible: GlobalStates.currentOverlay === GlobalStates.Overlay.Minimize

    Rectangle {
      id: minimizeBackground
      color: Theme.inactiveElement
      border {
        width: 2
        color: Theme.activeBorder
      }
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.topMargin: (minimize.height - minimize.minimizeHeight) / 2
      anchors.leftMargin: (minimize.width - minimize.minimizeWidth) / 2
      radius: Variables.radius
      opacity: 1
      width: minimize.minimizeWidth
      height: minimize.minimizeHeight
      visible: true
      property var minimizedToplevelsHyprland: {
        const allWs = Hyprland.workspaces.values;
        let minimizedWorkspace = allWs.filter(ws => ws.name === "special:minimized");
        if (minimizedWorkspace.length <= 0) {
          return [];
        }
        minimizedWorkspace = minimizedWorkspace[0];
        let allMinimizedTL = minimizedWorkspace.toplevels.values;
        if (allMinimizedTL.length <= 0) {
          return [];
        }
        return allMinimizedTL;
      }
      onMinimizedToplevelsHyprlandChanged: () => {
        GlobalStates.minimizedCount = minimizedToplevelsHyprland.length;
      }
      property var currentScreen: minimizedToplevelsHyprland[tlList.currentIndex]?.wayland || null
      RowLayout {
        spacing: 0
        anchors.fill: parent
        Rectangle {
          Layout.fillHeight: true
          Layout.fillWidth: true
          color: "transparent"
          ScreencopyView {
            id: activeWindow
            anchors.fill: parent
            anchors.leftMargin: minimize.gap
            anchors.topMargin: minimize.gap
            anchors.bottomMargin: minimize.gap
            captureSource: minimizeBackground.currentScreen
            paintCursor: false
            live: true
          }
        }
        Rectangle {
          Layout.fillHeight: true
          Layout.preferredWidth: 0.5 * minimize.minimizeWidth
          color: "transparent"
          ListView {
            id: tlList
            model: minimizeBackground.minimizedToplevelsHyprland
            anchors.fill: parent
            spacing: minimize.gap / 2
            anchors.margins: minimize.gap
            clip: true
            delegate: Rectangle {
              id: tlListRect
              required property var title
              required property var address
              width: tlList.width
              height: tlListText.height + 2 * minimize.gap
              color: Theme.barBgColour
              border.width: ListView.isCurrentItem ? 2 : 0
              border.color: Theme.activeBorder
              radius: 5
              Text {
                id: tlListText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: minimize.gap
                anchors.rightMargin: minimize.gap
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideMiddle
                text: `${tlListRect.title}`
                color: Theme.tlTextColour
              }
            }
          }
        }
      }
    }

    Component.onCompleted: {
      this.WlrLayershell.layer = WlrLayer.Overlay;
      this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
      this.WlrLayershell.namespace = "qsOverlay";
    }
  }
}
