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
      color: Theme.logoColour
      font.pointSize: Variables.fontSizeLogo
    }

    Process {
      id: rofiDrun
      command: ["rofi", "-show", "drun", "-theme-str", "window {location: northwest; anchor: northwest;}"]
      running: false
    }

    MouseArea {
      id: mouseArea
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      anchors.fill: parent
      hoverEnabled: true
      onClicked: function (event) {
        switch (event.button) {
        case Qt.LeftButton:
          {
            GlobalStates.controlCentreVisible = !GlobalStates.controlCentreVisible;
          }
          break;
        case Qt.RightButton:
          {
            rofiDrun.running = true;
          }
          break;
        }
      }
    }
  }
}
