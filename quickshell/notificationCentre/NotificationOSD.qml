pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQml.Models

import qs

Scope {
  id: root
  LazyLoader {
    loading: true
    PanelWindow {
      anchors {
        top: true
        right: true
      }
      margins {
        top: 4
        right: 4
      }
      color: "transparent"
      width: 300
      height: 100
      NotificationCard {
        content: {
          return NotificationData.showedNotifs[0];
        }
        index: 0
        visible: {
          if (NotificationData.showedNotifs.length === 0) {
            return false;
          }
          return true;
        }
      }
    }
  }
}
