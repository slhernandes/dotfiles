import QtQuick.Layouts

import qs.bar.widgets
import qs.bar.modules.items

ModuleBlock {
  id: root
  height: 32
  AudioOutputItem {
    implicitHeight: root.height
    Layout.alignment: Qt.AlignVCenter
  }
  BatteryItem {
    Layout.alignment: Qt.AlignVCenter
  }
}
