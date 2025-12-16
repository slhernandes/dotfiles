pragma Singleton

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
  id: root
  property var notifServer: null

  property var activeNotif: ({})

  Component {
    id: notifServerComponent
    NotificationServer {
      keepOnReload: false
      imageSupported: false
      actionsSupported: false
      onNotification: notif => handleNotif(notif)
    }
  }

  function updateNotifServer() {
    if (!!notifServer) {
      notifServer.destroy();
      notifServer = null;
    }
    notifServer = notifServerComponent.createObject(root);
  }

  Component.onCompleted: {
    updateNotifServer();
  }

  function handleNotif(notif) {
    const id = notif.id;
    const data = {
      "notif": notif,
      "metadata": {
        "id": id,
        "summary": notif.summary || "",
        "body": notif.body || "",
        // "appName": getAppName(n.appName || n.desktopEntry || ""),
        "urgency": notif.urgency < 0 || notif.urgency > 2 ? 1 : notif.urgency,
        "expireTimeout": notif.expireTimeout,
        "timestamp": new Date(),
        "progress": 1.0
      }
    };
    console.log(data.metadata.urgency);
    console.log(data.metadata.expireTimeout);
    console.log(Object.keys(root.activeNotif));
    activeNotif[id] = notif;
    notif.tracked = true;
    notif.closed.connect(() => delete activeNotif[id]);
  }

  Timer {
    interval: 100
    repeat: true
    running: {
      console.log("testing...");
      console.log(Object.keys(activeNotif).length);
      return Object.keys(activeNotif).length > 0;
    }
    onTriggered: updateNotifList()
  }

  function updateNotifList() {
    const now = Date.now();
    const durations = [3000, 6000, 9000];
    console.log("update is running");
    for (const i of Object.keys(activeNotif)) {
      const notifData = activeNotif[i];
      const urgency = notifData.urgency || 1;
      const duration = durations[urgency] || 6000;
      const expire = notifData.metadata.expireTimeout * 1000 || -1;
      if (now - notifData.metadata.timestamp >= duration) {
        notifData.notif.dismiss();
        delete activeNotif[i];
        continue;
      }
      if (now - notifData.metadata.timestamp >= expire && expire > 0) {
        notifData.notif.dismiss();
        delete activeNotif[i];
        continue;
      }
    }
  }
}
