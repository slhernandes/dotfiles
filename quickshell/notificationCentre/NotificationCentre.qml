import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

import qs

Scope {
  id: root

  property bool shouldShowOsd: false
  property bool isSink: true

  NotificationServer {
    imageSupported: true
    actionsSupported: true
  }

  LazyLoader {
    active: root.shouldShowOsd
    PanelWindow {
      anchors.top: true
      anchors.right: true
      margins.top: 4
      margins.right: 4
      exclusiveZone: 0

      implicitWidth: 400
      implicitHeight: 50
      color: "transparent"

      mask: Region {}
      Component.onCompleted: {
        this.WlrLayershell.layer = WlrLayer.Overlay;
        this.WlrLayershell.namespace = "qsVolumeOSD";
      }
    }
  }
}
