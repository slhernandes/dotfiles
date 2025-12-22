pragma Singleton

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root
  property int test: 10
  property var notifServer: null
  property ListModel activeList: ListModel {}
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

  function findIndexFromId(id) {
    for (let i = 0; i < activeList.count; i++) {
      if (activeList.get(i).metadata.id === id) {
        return i;
      }
    }
    return -1;
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
    activeNotif[id] = data;
    activeList.insert(0, data);
    notif.tracked = true;
    notif.closed.connect(() => {
      delete activeNotif[id];
      const idx = findIndexFromId(id);
      if (idx >= 0) {
        activeList.remove(idx);
      }
    });
  }

  Timer {
    interval: 100
    repeat: true
    running: root.activeList.count > 0
    onTriggered: root.updateNotifList()
  }

  function updateNotifList() {
    const now = Date.now();
    const durations = [3000, 6000, 9000];
    for (const i of Object.keys(activeNotif)) {
      const notifData = activeNotif[i];
      const urgency = notifData.urgency || 1;
      const duration = durations[urgency] || 6000;
      const expire = notifData.metadata.expireTimeout * 1000 || -1;
      if (now - notifData.metadata.timestamp >= duration) {
        deactivateNotif(i);
        continue;
      }
      if (now - notifData.metadata.timestamp >= expire && expire > 0) {
        deactivateNotif(i);
        continue;
      }
    }
  }

  function deactivateNotif(id) {
    activeNotif[id].notif.dismiss();
    delete activeNotif[id];
    const idx = findIndexFromId(id);
    if (idx >= 0) {
      activeList.remove(idx);
    }
  }
}
