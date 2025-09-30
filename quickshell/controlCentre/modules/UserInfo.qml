pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import qs
import qs.controlCentre.widgets

Item {
  id: root
  property string hostname
  property string username

  CCModuleBlock {
    width: content.width + 16
    height: content.height + 16
    ColumnLayout {
      id: content
      anchors.centerIn: parent
      spacing: 4
      height: layoutHostname.implicitHeight + layoutUsername.implicitHeight + 4
      width: Math.max(layoutHostname.implicitWidth, layoutUsername.implicitWidth)
      RowLayout {
        id: layoutHostname
        spacing: 4
        implicitHeight: iconHostname.implicitSize
        implicitWidth: iconHostname.implicitSize + textHostname.width + 4
        IconImage {
          id: iconHostname
          implicitSize: 16
          source: Quickshell.iconPath("computer-laptop-symbolic")
        }
        Rectangle {
          color: "transparent"
          implicitHeight: iconHostname.implicitHeight
          implicitWidth: textHostname.width
          Text {
            id: textHostname
            anchors.centerIn: parent
            font.family: Variables.fontFamilyText
            font.pointSize: Variables.fontSizeText
            text: root.hostname
          }
        }
      }
      RowLayout {
        id: layoutUsername
        spacing: 4
        implicitHeight: iconUsername.implicitSize
        implicitWidth: iconUsername.implicitSize + textUsername.width + 4
        IconImage {
          id: iconUsername
          implicitSize: 16
          source: Quickshell.iconPath("user-symbolic")
        }
        Rectangle {
          color: "transparent"
          implicitHeight: iconUsername.implicitHeight
          implicitWidth: textUsername.width
          Text {
            id: textUsername
            anchors.centerIn: parent
            font.family: Variables.fontFamilyText
            font.pointSize: Variables.fontSizeText
            text: root.username
          }
        }
      }
    }
  }
  Process {
    id: userInfoUsername
    command: ["whoami"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: function () {
        root.username = this.text;
      }
    }
  }
  Process {
    id: userInfoHostname
    command: ["hostname"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: function () {
        root.hostname = this.text;
      }
    }
  }
}
