import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.bar.widgets
import qs.bar.modules.items

ModuleBlock {
  RowLayout {
    id: systrayRow
    spacing: 0
    visible: SystemTray.items.values.length > 0
    Repeater {
      model: SystemTray.items.values
      SystemTrayModuleItem {}
    }
  }
}
