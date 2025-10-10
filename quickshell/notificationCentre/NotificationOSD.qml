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
      ColumnLayout {
        Instantiator {
          model: GlobalStates.showedNotifs
          delegate: NotificationCard {
            required property Notification modelData
            content: {
              console.log(modelData);
              return modelData;
            }
          }
        }
      }
    }
  }
}
