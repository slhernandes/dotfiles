pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import qs

Scope {
  id: root
  PanelWindow {
    id: launcher
    property real launcherWidth: 400
    property real launcherHeight: 600
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
      id: launcherMouseArea
      anchors.fill: parent
      onClicked: function () {
        if (!ncBackground.contains(Qt.point(mouseX, mouseY - Variables.barHeight - 4))) {
          GlobalStates.launcherVisible = false;
        }
      }
    }

    Shortcut {
      sequence: "escape"
      onActivated: () => {
        if (input.selectedText === "") {
          GlobalStates.launcherVisible = false;
        } else {
          input.deselect();
        }
      }
    }

    anchors {
      top: true
      left: true
      bottom: true
      right: true
    }

    margins.top: -Variables.barHeight

    visible: GlobalStates.launcherVisible

    Rectangle {
      id: launcherBackground
      color: Theme.inactiveElement
      border {
        width: 2
        color: Theme.activeBorder
      }
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.topMargin: Variables.barHeight + 4
      anchors.leftMargin: (launcher.width - launcher.launcherWidth) / 2
      radius: Variables.radius
      opacity: Variables.ncBgOpacity
      width: launcher.launcherWidth
      height: launcher.launcherHeight
      visible: true

      TextField {
        id: input
        placeholderText: qsTr("Hello, World")
        placeholderTextColor: Theme.launcherTextColour
        cursorVisible: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: launcher.gap
        anchors.topMargin: launcher.gap
        width: parent.width - 2 * launcher.gap
        focus: true
        Keys.onPressed: event => {
          if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_A) {
            cursorPosition = 0;
            event.accepted = true;
          } else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_E) {
            cursorPosition = text.length;
            event.accepted = true;
          } else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_Y) {
            paste();
            event.accepted = true;
          } else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_F) {
            cursorPosition += 1;
            event.accepted = true;
          } else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_B) {
            cursorPosition -= 1;
            event.accepted = true;
          } else if (event.modifiers & Qt.AltModifier && event.key === Qt.Key_F) {
            // TODO: Fix multi space behaviour
            let cPosTemp = text.length;
            for (let i = cursorPosition + 1; i < text.length; i++) {
              if (text[i] === " ") {
                cPosTemp = i;
                break;
              }
            }
            cursorPosition = cPosTemp;
            event.accepted = true;
          } else if (event.modifiers & Qt.AltModifier && event.key === Qt.Key_B) {
            // TODO: Fix multi space behaviour
            let cPosTemp = 0;
            for (let i = cursorPosition - 2; i >= 0; i--) {
              if (text[i] === " ") {
                cPosTemp = i + 1;
                break;
              }
            }
            cursorPosition = cPosTemp;
            event.accepted = true;
          } else if (event.modifiers & Qt.AltModifier && event.key === Qt.Key_D) {
            // TODO: Delete Forward Word
          } else if (event.modifiers & Qt.AltModifier && event.key === Qt.Key_Backspace) {
            // TODO: Delete Backward Word
          } else if (event.modifiers & Qt.AltModifier && event.key === Qt.Key_W) {
            copy();
            event.accepted = true;
          } else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_W) {
            cut();
            event.accepted = true;
          }
        }
      }
    }

    Component.onCompleted: {
      this.WlrLayershell.layer = WlrLayer.Overlay;
      this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
      this.WlrLayershell.namespace = "qsLauncher";
    }
  }
}
