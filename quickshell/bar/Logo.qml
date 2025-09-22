import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import "root:/"

RowLayout {
  property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
  Rectangle {
    id: logo

    Layout.preferredWidth: logoText.width
    Layout.preferredHeight: 32
    radius: 5
    color: Theme.get.barBgColour
    border {
      color: "#5b6078"
      width: 2
    }
    opacity: 0.85

    Text {
      id: logoText
      anchors.centerIn: parent
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      padding: 12
      text: ""
      color: Theme.get.logoColour
      font.pointSize: 18
    }

    Process {
      id: rofiDrun
      command: ["rofi", "-show", "drun", "-theme-str", "window {location: northwest; anchor: northwest;}"]
      running: false
    }

    Process {
      id: rofiPower
      command: ["../scripts/sddmenu"]
      running: false
    }

    // Timer {
    //   interval: 1000
    //   running: true
    //   repeat: true
    //   onTriggered: dateProc.running = true
    // }

    MouseArea {
      id: mouseAreaLeft
      acceptedButtons: Qt.LeftButton
      anchors.fill: parent
      hoverEnabled: true
      onClicked: rofiDrun.running = true
    }

    MouseArea {
      id: mouseAreaRight
      acceptedButtons: Qt.RightButton
      anchors.fill: parent
      hoverEnabled: true
      onClicked: rofiPower.running = true
    }
  }
}
