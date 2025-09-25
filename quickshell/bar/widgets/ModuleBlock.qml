import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs

RowLayout {
  id: root
  property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
  property int extraWidth: 16
  property int spacing: 8
  default required property list<Item> items

  signal specialWidthChanged

  Rectangle {
    id: moduleRect
    Layout.preferredWidth: moduleRow.width + root.extraWidth
    Layout.preferredHeight: 32
    implicitHeight: 32
    radius: 5
    color: Theme.get.barBgColour
    border {
      color: Theme.get.borderColour
      width: 2
    }
    opacity: 0.85

    RowLayout {
      id: moduleRow
      height: parent.implicitHeight
      anchors.centerIn: parent
      spacing: root.spacing
      children: root.items
    }
  }

  onSpecialWidthChanged: {
    const itemList = root.items;
    let newWidth = 0;
    let itemCount = 0;
    for (const item of itemList) {
      if (item instanceof Repeater) {
        itemCount += item.count;
      } else {
        itemCount++;
      }
      newWidth += item.width;
    }
    moduleRow.width = newWidth + (itemCount - 1) * moduleRow.spacing;
  }
}
