import QtQuick.Layouts

import qs.bar.widgets
import qs.bar.modules.items

ModuleBlock {
  id: root
  height: 32
  width: windowItem.implicitWidth
  visible: windowItem.implicitWidth == 0 ? false : true
  CurrentWindowItem {
    id: windowItem
    height: parent.height
    implicitWidth: this.width
    Layout.alignment: Qt.AlignCenter
  }
}
