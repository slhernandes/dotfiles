import QtQuick.Layouts

import qs.bar.widgets
import qs.bar.modules.items

ModuleBlock {
  id: root
  height: 32
  width: submapItem.implicitWidth
  SubmapItem {
    id: submapItem
    height: parent.height
    implicitWidth: this.width
    Layout.alignment: Qt.AlignCenter
  }
}
