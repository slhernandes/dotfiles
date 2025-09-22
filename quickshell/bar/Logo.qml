import QtQuick.Layouts
import Quickshell.Hyprland
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
    // MouseArea {
    //   id: mouseArea
    //   anchors.fill: parent
    //   hoverEnabled: true
    // }
  }
}
