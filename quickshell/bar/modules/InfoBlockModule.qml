import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "./items"
import "../../"

RowLayout {
  property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

  Rectangle {
    id: infoBlockBar
    Layout.preferredWidth: infoBlockRow.width + 8
    Layout.preferredHeight: 32
    radius: 5
    color: Theme.get.barBgColour
    border {
      color: Theme.get.borderColour
      width: 2
    }
    opacity: 0.85

    Row {
      id: infoBlockRow

      anchors.centerIn: parent
      spacing: 0
      DateItem {}
    }
  }
}
