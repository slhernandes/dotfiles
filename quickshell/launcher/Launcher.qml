pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import qs
import qs.launcher.providers

Scope {
  id: root
  PanelWindow {
    id: launcher
    property real launcherWidth: 400
    property real launcherHeight: 600
    property var provider: {
      switch (GlobalStates.launcherProvider) {
      case "appLauncher":
        {
          return AppLauncherProvider;
        }
        break;
      case "pdf":
        {
          return PdfProvider;
        }
        break;
      default:
        {
          console.log("Launcher.provider: UNREACHABLE!");
          return AppLauncherProvider;
        }
      }
    }
    property var items: provider.items
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
        if (!launcherBackground.contains(Qt.point(mouseX, mouseY - Variables.barHeight - 4))) {
          GlobalStates.currentOverlay = GlobalStates.Overlay.None;
          launcherList.currentIndex = 0;
          input.clear();
        }
      }
    }

    Shortcut {
      sequence: "escape"
      onActivated: () => {
        if (input.selectedText === "") {
          GlobalStates.currentOverlay = GlobalStates.Overlay.None;
          launcherList.currentIndex = 0;
          input.clear();
        } else {
          input.deselect();
        }
      }
    }

    Shortcut {
      sequence: "Ctrl+n"
      onActivated: () => {
        launcherList.incrementCurrentIndex();
      }
    }

    Shortcut {
      sequence: "Ctrl+p"
      onActivated: () => {
        launcherList.decrementCurrentIndex();
      }
    }

    Shortcut {
      sequence: "Return"
      onActivated: () => {
        GlobalStates.currentOverlay = GlobalStates.Overlay.None;
        launcherList.forceLayout();
        const item = launcherList.model[launcherList.currentIndex];
        launcher.provider.execute(item);
        input.clear();
        launcherList.currentIndex = 0;
      }
    }

    anchors {
      top: true
      left: true
      bottom: true
      right: true
    }

    margins.top: -Variables.barHeight

    visible: GlobalStates.currentOverlay === GlobalStates.Overlay.Launcher
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
      anchors.leftMargin: {
        switch (GlobalStates.launcherPosition) {
        case "left":
          {
            return 0;
          }
          break;
        case "center":
          {
            return (launcher.width - launcher.launcherWidth) / 2;
          }
          break;
        case "right":
          {
            return launcher.width - launcher.launcherWidth;
          }
          break;
        default:
          {
            return (launcher.width - launcher.launcherWidth) / 2;
          }
        }
      }
      radius: Variables.radius
      opacity: Variables.ncBgOpacity
      width: launcher.launcherWidth
      height: launcher.launcherHeight
    }

    Rectangle {
      color: "transparent"
      anchors.fill: launcherBackground
      radius: Variables.radius

      ColumnLayout {
        id: launcherColumn
        anchors.fill: parent
        anchors.margins: launcher.gap
        spacing: launcher.gap
        TextField {
          id: input
          placeholderText: qsTr(launcher.provider.placeholderText)
          placeholderTextColor: Theme.launcherTextColour
          cursorVisible: true
          Layout.fillWidth: true
          focus: true
          background: Rectangle {
            color: Theme.barBgColour
            opacity: Variables.barOpacity
            radius: Variables.radius
          }
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
              let cPosTemp = cursorPosition;
              for (let i = cursorPosition; i <= text.length; i++) {
                cPosTemp = i;
                if (text[i] !== " " && text[i] !== "\t") {
                  break;
                }
              }
              for (let i = cPosTemp; i <= text.length; i++) {
                cPosTemp = i;
                if (text[i] === " ") {
                  break;
                }
              }
              cursorPosition = cPosTemp;
              event.accepted = true;
            } else if (event.modifiers & Qt.AltModifier && event.key === Qt.Key_B) {
              let cPosTemp = cursorPosition;
              for (let i = cursorPosition - 1; i >= 0; i--) {
                cPosTemp = i;
                if (text[i] !== " " && text[i] !== "\t") {
                  break;
                }
              }
              for (let i = cPosTemp; i >= 0; i--) {
                cPosTemp = i;
                if (text[i] === " " && i !== 0) {
                  cPosTemp++;
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
        ListView {
          id: launcherList
          model: {
            const text = input.text;
            let filteredItems = [];
            for (const item of launcher.items) {
              const itemNameLower = item.name?.toLowerCase() || "";
              if (itemNameLower.includes(text.toLowerCase())) {
                filteredItems.push(item);
              }
            }
            return filteredItems;
          }
          Layout.fillHeight: true
          Layout.fillWidth: true
          keyNavigationEnabled: true
          keyNavigationWraps: true
          spacing: launcher.gap / 2
          clip: true
          highlightMoveDuration: 30
          delegate: Rectangle {
            id: delegateRoot
            required property string name
            required property string icon
            required property int index
            radius: Variables.radius
            opacity: Variables.barOpacity
            height: launcherListText.height + 2 * launcher.gap
            width: launcherList.width
            color: Theme.barBgColour
            border {
              width: ListView.isCurrentItem ? 2 : 0
              color: Theme.activeBorder
            }
            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              onClicked: () => launcherList.currentIndex = delegateRoot.index
              onDoubleClicked: () => {
                GlobalStates.currentOverlay = GlobalStates.Overlay.None;
                launcherList.forceLayout();
                const item = launcherList.model[launcherList.currentIndex];
                launcher.provider.execute(item);
                input.clear();
                launcherList.currentIndex = 0;
              }
            }
            RowLayout {
              spacing: launcher.gap
              anchors.verticalCenter: parent.verticalCenter
              anchors.fill: parent
              anchors.leftMargin: launcher.gap
              Rectangle {
                Layout.fillHeight: launcher.provider.showIcons ? true : false
                Layout.preferredWidth: launcher.provider.showIcons ? parent.height - 2 * launcher.gap : 0
                color: "transparent"
                IconImage {
                  anchors.fill: parent
                  source: Quickshell.iconPath(delegateRoot.icon)
                  implicitSize: parent.height
                }
              }
              Text {
                id: launcherListText
                Layout.fillWidth: true
                elide: Text.ElideMiddle
                text: `${delegateRoot.name}`
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
