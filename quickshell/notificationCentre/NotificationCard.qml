import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQml.Models

import qs

Rectangle {
  id: root
  property int index
  property Notification content
  property bool show: true
  signal updateIndex(idx: int)

  border {
    width: 2
    color: Theme.activeBorder
  }
  radius: Variables.radius
  color: Theme.barBgColour
  opacity: Variables.barOpacity
  width: 300
  height: 100

  RowLayout {
    anchors.centerIn: parent
    IconImage {
      implicitSize: 80
      source: content?.image || content?.appIcon || `file://${Variables.configDir}/icons/hakase_no_img.png`
    }
    ColumnLayout {
      Text {
        text: {
          console.log("content body:", root.content?.body);
          return "Hello";
        }
      }
    }
  }

  Timer {
    interval: 3000
    running: true
    repeat: false
    onTriggered: root.show = false
  }

  onUpdateIndex: function (idx) {
    root.index = idx;
  }
}
