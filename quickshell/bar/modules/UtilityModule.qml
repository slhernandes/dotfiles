import QtQuick.Layouts
import QtQuick

import qs.bar.widgets
import qs.bar.modules.items

ModuleBlock {
  id: root
  height: 32
  AudioOutputItem {
    height: root.height
    Layout.alignment: Qt.AlignVCenter
  }
  BatteryItem {
    height: root.height
    Layout.alignment: Qt.AlignVCenter
  }
}
