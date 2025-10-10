import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

import qs
import qs.notificationCentre

Scope {
  id: root

  property bool shouldShowOsd: false
  property bool isSink: true

  NotificationServer {
    imageSupported: true
    actionsSupported: true
    onNotification: function (notification) {
      notification.tracked = true;
      // console.log("----------------");
      // console.log(notification.appName);
      // console.log(notification.appIcon);
      // console.log(notification.image);
      // console.log(notification.body);
      // console.log(notification.summary);
      // console.log(notification.urgency);
      // console.log(notification.desktopEntry);
      // console.log(notification.hints?.SWAYNC_BYPASS_DND);
      // console.log(notification.expireTimeout);
      // console.log("----------------");
      GlobalStates.activeNotifCount += 1;
      GlobalStates.showedNotifs.push(notification);
      notification.expire();
    }
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
      Rectangle {
        color: "transparent"
        width: 400
        height: 50
      }
      Component.onCompleted: {
        this.WlrLayershell.layer = WlrLayer.Overlay;
        this.WlrLayershell.namespace = "qsNotificationCentre";
      }
    }
  }
}
