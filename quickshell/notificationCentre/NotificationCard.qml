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
          return root.content.body;
        }
      }
    }
  }

  MouseArea {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 5
    anchors.rightMargin: 5
    implicitWidth: inside.width
    implicitHeight: inside.height
    Rectangle {
      id: inside
      anchors.centerIn: parent
      width: 20
      height: 20
      radius: 5
    }
    onClicked: function (event) {
      if (NotificationData.showedNotifs.length > 0) {
        NotificationData.showedNotifs[root.index].dismiss();
        NotificationData.showedNotifs.splice(root.index, 1);
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
