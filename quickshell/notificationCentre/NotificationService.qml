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
  property ListModel ncList: ListModel {}
  property var activeNotif: ({})
  signal deactivateNotifSignal(notifId: string, partial: bool)

  Component {
    id: notifServerComponent
    NotificationServer {
      keepOnReload: false
      imageSupported: true
      actionsSupported: true
      onNotification: notif => {
        notif.tracked = true;
        handleNotif(notif);
      }
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

  function findNotifFromXcps(xcps) {
    for (const nid of Object.keys(activeNotif)) {
      if (activeNotif[nid].metadata.xcps === xcps) {
        return parseInt(nid);
      }
    }
    return -1;
  }

  function findNcIndexFromId(id) {
    for (let i = 0; i < ncList.count; i++) {
      if (ncList.get(i).metadata.id === id) {
        return i;
      }
    }
    return -1;
  }

  function findActiveIndexFromId(id) {
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
        "transient": notif.hints["transient"] || 0,
        "xcps": notif.hints["x-canonical-private-synchronous"] || notif.hints["synchronous"] || "",
        "dndBypass": notif.hints["dnd-bypass"] || notif.hints["SWAYNC_BYPASS_DND"] || false,
        "summary": notif.summary || "",
        "body": notif.body || "",
        "urgency": notif.urgency < 0 || notif.urgency > 2 ? 1 : notif.urgency,
        "expireTimeout": notif.expireTimeout,
        "timestamp": new Date(),
        "progress": 1.0
      }
    };
    if (data.metadata.xcps !== "") {
      const oldNid = findNotifFromXcps(data.metadata.xcps);
      if (oldNid != -1) {
        if (!GlobalStates.dndEnabled || data.metadata.dndBypass || data.metadata.transient !== 0) {
          const alid = findActiveIndexFromId(oldNid);
          activeList.set(alid, data);
        }

        if (data.metadata.transient === 0) {
          const ncid = findNcIndexFromId(oldNid);
          ncList.set(ncid, data);
        }

        activeNotif[id] = data;
        activeNotif[oldNid].notif.dismiss();
      } else {
        const isNewId = !activeNotif[id];
        activeNotif[id] = data;
        if (isNewId) {
          if (!GlobalStates.dndEnabled || data.metadata.dndBypass || data.metadata.transient !== 0) {
            activeList.insert(0, data);
          }
          if (data.metadata.transient === 0) {
            ncList.append(data);
          }
        }
      }
    } else {
      const isNewId = !activeNotif[id];
      activeNotif[id] = data;
      if (isNewId) {
        activeList.insert(0, data);
        if (data.metadata.transient === 0) {
          ncList.append(data);
        }
      }
    }
    notif.closed.connect(() => {
      delete activeNotif[id];
      let idx = findActiveIndexFromId(id);
      if (idx >= 0) {
        activeList.remove(idx);
      }
      idx = findNcIndexFromId(id);
      if (idx >= 0) {
        ncList.remove(idx);
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
      const urgency = notifData.metadata.urgency || 1;
      const duration = durations[urgency] || 6000;
      const expire = notifData.metadata.expireTimeout || -1;
      if (now - notifData.metadata.timestamp >= duration && expire < 0) {
        deactivateNotifSignal(i, true);
        continue;
      }
      if (now - notifData.metadata.timestamp >= expire && expire > 0) {
        deactivateNotifSignal(i, true);
        continue;
      }
    }
  }

  function deactivateNotif(id, partial) {
    if (partial) {
      const alid = findActiveIndexFromId(id);
      if (alid !== -1) {
        activeList.remove(alid);
      }
    } else {
      dismissNotif(id);
    }
  }

  function dismissNotif(id) {
    activeNotif[id].notif.dismiss();
  }

  function dismissAllNotif() {
    for (const id of Object.keys(activeNotif)) {
      dismissNotif(id);
    }
  }
}
