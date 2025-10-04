import QtQuick
import QtQuick.Layouts
// import Quickshell.Hyprland

import qs

RowLayout {
  id: root
  // property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
  property int extraWidth: 16
  property int spacing: 8
  default required property list<Item> items

  signal specialWidthChanged

  Rectangle {
    id: moduleRect
    Layout.preferredWidth: moduleRow.width + root.extraWidth
    Layout.preferredHeight: 32
    implicitHeight: 32
    radius: Variables.radius
    color: Theme.barBgColour
    border {
      color: Theme.borderColour
      width: Variables.borderWidth
    }
    opacity: Variables.barOpacity

    RowLayout {
      id: moduleRow
      implicitHeight: moduleRect.implicitHeight
      anchors.centerIn: parent
      spacing: root.spacing
      children: root.items
    }
  }
}
