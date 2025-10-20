import QtQuick
import QtQuick.Layouts

import qs
import qs.bar
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
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: function () {
        currentWindowNameTooltip.activateTooltip();
      }
      onExited: function () {
        currentWindowNameTooltip.deactivateTooltip();
      }
    }
    Tooltip {
      id: currentWindowNameTooltip
      parentItem: root
      Component {
        Rectangle {
          id: tooltipBox
          color: Theme.barBgColour
          opacity: 0
          radius: Variables.radius
          border.width: Variables.borderWidth
          border.color: Theme.borderColour
          width: tooltipText.width
          height: tooltipText.height
          Text {
            id: tooltipText
            anchors.centerIn: parent
            text: HyprlandUtils.currentActiveWindowTitle.toString()
            font.pointSize: Variables.fontSizeTooltip
            padding: Variables.paddingTooltip
            color: Theme.tooltipColour
          }
          Behavior on opacity {
            NumberAnimation {
              duration: 150
            }
          }
        }
      }
    }
  }
}
