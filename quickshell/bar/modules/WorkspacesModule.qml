import QtQuick

import qs.bar.modules.items
import qs.bar.widgets

ModuleBlock {
  id: root
  spacing: 0
  Repeater {
    id: normalWs
    model: 9
    WorkspaceItem {
      id: wsElem
    }
    onItemAdded: function (index, item) {
      normalWs.width += item.width;
    }
  }

  WorkspaceItem {
    id: specialWs
    modelData: -1
    visible: false
  }
}
