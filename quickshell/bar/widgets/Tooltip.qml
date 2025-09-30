pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQml

import qs

Scope {
  id: root
  required property Item parentItem
  default property Component tooltipContent
  signal activateTooltip
  signal deactivateTooltip
  LazyLoader {
    id: tooltipLoader
    active: false
    component: Component {
      PopupWindow {
        id: tooltipWindow
        anchor {
          item: root.parentItem
          rect.y: root.parentItem.height
          rect.x: 0
        }
        implicitWidth: content.item.width
        implicitHeight: content.item.height + 4
        color: "transparent"
        Loader {
          id: content
          anchors.centerIn: parent
          sourceComponent: root.tooltipContent
          active: true
        }
        onVisibleChanged: function () {
          content.item.opacity = visible ? Variables.barOpacity : 0;
        }
      }
    }
  }
  Timer {
    id: showTooltipTimer
    interval: 300
    repeat: false
    running: false
    triggeredOnStart: false
    onTriggered: function () {
      tooltipLoader.loading = true;
      tooltipLoader.item.visible = true;
    }
  }
  onActivateTooltip: function () {
    showTooltipTimer.start();
  }
  onDeactivateTooltip: function () {
    showTooltipTimer.stop();
    if (tooltipLoader.active) {
      tooltipLoader.item.visible = false;
    }
  }
}
