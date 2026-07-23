pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts

import qs
import qs.wallpaper

Scope {
  id: root
  PanelWindow {
    id: wallPicker
    property real monitorWidth: width
    property real monitorHeight: height + Variables.barHeight
    property real previewWidth: 3 / 16 * monitorWidth
    property real listWidth: 2 / 16 * monitorWidth
    property real wallPickerWidth: previewWidth + listWidth
    property real wallPickerHeight: (previewWidth - gap) * 9 / 16 + 2 * gap
    property list<var> wallItems: []
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
      id: wallPickerMouseArea
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
        wpList.incrementCurrentIndex();
      }
    }

    Shortcut {
      sequence: "Ctrl+p"
      onActivated: () => {
        wpList.decrementCurrentIndex();
      }
    }

    Shortcut {
      sequence: "Return"
      onActivated: () => {
        const item = wpList.currentItem;
        if (!item) {
          return;
        }
        GlobalStates.currentOverlay = GlobalStates.Overlay.None;
        const pref = Wallpaper.wallpaper.checkTime();
        Wallpaper.wallpaper.changeWallpaper(`${pref}_${item.name}`);
      }
    }

    anchors {
      top: true
      left: true
      bottom: true
      right: true
    }

    Process {
      running: true
      command: ["sh", "-c", `ls ${Variables.wallDir}`]
      stdout: StdioCollector {
        onStreamFinished: () => {
          let walls = this.text.split("\n").map(x => x.split(".", 1)[0]).filter(x => x.startsWith("day_") || x.startsWith("night_")).map(x => x.split("_", 2)[1]).sort();
          let ret = [];
          for (let i = 0; i < walls.length - 1; i++) {
            if (walls[i] === walls[i + 1]) {
              ret.push(walls[i]);
            }
          }
          ret = ret.map(x => {
            return {
              name: x
            };
          });
          Qt.callLater(() => wallPicker.wallItems = ret);
        }
      }
    }

    margins.top: -Variables.barHeight

    visible: GlobalStates.currentOverlay === GlobalStates.Overlay.WallPicker

    Rectangle {
      id: wallPickerBackground
      color: Theme.inactiveElement
      border {
        width: 2
        color: Theme.activeBorder
      }
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.topMargin: (wallPicker.height - wallPicker.wallPickerHeight) / 2
      anchors.leftMargin: (wallPicker.width - wallPicker.wallPickerWidth) / 2
      radius: Variables.radius
      opacity: Variables.barOpacity
      width: wallPicker.wallPickerWidth
      height: wallPicker.wallPickerHeight
      visible: true
      RowLayout {
        spacing: 0
        anchors.fill: parent
        Rectangle {
          id: previewRect
          Layout.fillHeight: true
          Layout.preferredWidth: wallPicker.previewWidth
          color: "transparent"
          Image {
            id: dayImage
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: wallPicker.gap
            anchors.topMargin: wallPicker.gap
            anchors.bottomMargin: wallPicker.gap
            layer.enabled: true
            visible: false
            asynchronous: false
            cache: true
            source: `file://${Variables.wallDir}/day_${wpList.currentItem?.name}.png`
            sourceSize.width: width
            sourceSize.height: height
          }
          Image {
            id: nightImage
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: wallPicker.gap
            anchors.topMargin: wallPicker.gap
            anchors.bottomMargin: wallPicker.gap
            layer.enabled: true
            visible: false
            asynchronous: false
            cache: true
            source: `file://${Variables.wallDir}/night_${wpList.currentItem?.name}.png`
            sourceSize.width: width
            sourceSize.height: height
          }
          Shape {
            id: imageShape
            anchors.fill: parent
            anchors.leftMargin: wallPicker.gap
            anchors.topMargin: wallPicker.gap
            anchors.bottomMargin: wallPicker.gap
            preferredRendererType: Shape.CurveRenderer
            visible: false
            layer.enabled: true
            ShapePath {
              PathLine {
                x: 0
                y: 0
              }
              PathLine {
                x: imageShape.width
                y: 0
              }
              PathLine {
                x: 0
                y: imageShape.height
              }
              strokeColor: "transparent"
            }
          }
          MultiEffect {
            anchors.fill: parent
            anchors.leftMargin: wallPicker.gap
            anchors.topMargin: wallPicker.gap
            anchors.bottomMargin: wallPicker.gap
            source: nightImage
            maskSpreadAtMin: 1.0
            maskThresholdMin: 0.5
            maskEnabled: true
            maskSource: imageShape
          }
          MultiEffect {
            anchors.fill: parent
            anchors.leftMargin: wallPicker.gap
            anchors.topMargin: wallPicker.gap
            anchors.bottomMargin: wallPicker.gap
            source: dayImage
            maskInverted: true
            maskSpreadAtMin: 1.0
            maskThresholdMin: 0.5
            maskEnabled: true
            maskSource: imageShape
          }
        }
        Rectangle {
          Layout.fillHeight: true
          Layout.preferredWidth: wallPicker.listWidth
          color: "transparent"
          ListView {
            id: wpList
            model: wallPicker.wallItems
            anchors.fill: parent
            spacing: wallPicker.gap / 2
            anchors.margins: wallPicker.gap
            clip: true
            delegate: Rectangle {
              id: wpListRect
              required property var name
              width: wpList.width
              height: wpListText.height + 2 * wallPicker.gap
              color: Theme.barBgColour
              border.width: ListView.isCurrentItem ? 2 : 0
              border.color: Theme.activeBorder
              radius: 5
              Text {
                id: wpListText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: wallPicker.gap
                anchors.rightMargin: wallPicker.gap
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideMiddle
                text: `${wpListRect.name}`
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
