import QtQuick

import qs

Item {
  id: root
  default required property list<Item> items
  Rectangle {
    color: Theme.barBgColour
    radius: Variables.radius
    children: root.items
    width: root.width
    height: root.height
    opacity: Variables.barOpacity
  }
}
