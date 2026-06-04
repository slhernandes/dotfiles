import Quickshell
import Quickshell.Io
import QtQuick

import qs
import qs.bar.widgets

ModuleBlock {
  id: root
  extraWidth: 0
  Item {
    width: Math.ceil(logoText.width)
    height: parent.height
    Text {
      id: logoText
      anchors.centerIn: parent
      padding: 12
      text: ""
      color: Theme.logoColour
      font.pointSize: Variables.fontSizeLogo
      font.family: Variables.fontFamilyLogo
    }

    Process {
      id: rofiDrun
      command: ["rofi", "-show", "drun", "-theme-str", "window {location: northwest; anchor: northwest;}"]
      // command: ["sh", "-c", "hyprshutdown -t 'Shutting down...' -p 'poweroff' &> /home/samuelhernandes/Dokumente/test/hyprshutdown.log"]
      running: false
    }

    MouseArea {
      id: mouseArea
      cursorShape: Qt.PointingHandCursor
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      anchors.fill: parent
      hoverEnabled: true
      onClicked: function (event) {
        switch (event.button) {
        case Qt.LeftButton:
          {
            GlobalStates.controlCentreVisible = !GlobalStates.controlCentreVisible;
            GlobalStates.monitorName = root.QsWindow.window?.screen.name;
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
