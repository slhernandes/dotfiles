import Quickshell.Io
import QtQuick

import qs
import qs.bar.widgets

ModuleBlock {
  extraWidth: 0
  Item {
    width: Math.ceil(logoText.width)
    height: parent.height
    Text {
      id: logoText
      anchors.centerIn: parent
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      padding: 12
      text: ""
      color: Theme.get.logoColour
      font.pointSize: Variables.fontSizeLogo
    }

    Process {
      id: rofiDrun
      command: ["rofi", "-show", "drun", "-theme-str", "window {location: northwest; anchor: northwest;}"]
      running: false
    }

    Process {
      id: rofiPower
      command: [Variables.configDir + "/scripts/powermenu"]
      running: false
    }

    MouseArea {
      id: mouseArea
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      anchors.fill: parent
      hoverEnabled: true
      onClicked: function (event) {
        // console.log(event.button);
        switch (event.button) {
        case Qt.LeftButton:
          rofiDrun.running = true;
          break;
        case Qt.RightButton:
          rofiPower.running = true;
          break;
        }
      }
    }
  }
}
