import QtQuick
import QtQuick.Layouts

import qs
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
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      propagateComposedEvents: true
      onEntered: function () {
        submapTooltip.activateTooltip();
      }
      onExited: function () {
        submapTooltip.deactivateTooltip();
      }
    }
    Tooltip {
      id: submapTooltip
      parentItem: root
      delay: 50
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
            text: {
              if (submapItem.submap == "PASSTHROUGH") {
                return submapItem.submap + " (SUPER+ESCAPE to exit)";
              }
              return submapItem.submap;
            }
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
