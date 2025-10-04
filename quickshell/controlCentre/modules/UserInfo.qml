pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

import qs
import qs.controlCentre.widgets

Item {
  id: root
  property string hostname
  property string username
  property string uptime
  required property real cellSize
  required property real moduleGap

  RowLayout {
    spacing: 8
    CCModuleBlock {
      implicitWidth: root.cellSize
      implicitHeight: root.cellSize
      Rectangle {
        id: mask
        visible: false
        width: userIcon.implicitSize
        height: userIcon.implicitSize
        anchors.centerIn: parent
        radius: 999
      }
      IconImage {
        id: userIcon
        anchors.centerIn: parent
        visible: false
        source: `file:///usr/share/sddm/faces/${root.username.trim()}.face.icon`
        implicitSize: 80
      }
      OpacityMask {
        anchors.fill: userIcon
        source: userIcon
        maskSource: mask
      }
    }
    CCModuleBlock {
      implicitWidth: root.cellSize * 2 + root.moduleGap
      implicitHeight: root.cellSize
      ColumnLayout {
        id: content
        anchors.centerIn: parent
        spacing: 4
        height: layoutHostname.implicitHeight + layoutUsername.implicitHeight + layoutUptime.implicitHeight + 4
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
              color: Theme.ccTextColour
              font.family: Variables.fontFamilyTextCC
              font.pointSize: Variables.fontSizeText
              text: root.hostname.trim()
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
              color: Theme.ccTextColour
              font.family: Variables.fontFamilyTextCC
              font.pointSize: Variables.fontSizeText
              text: root.username.trim()
            }
          }
        }
        RowLayout {
          id: layoutUptime
          spacing: 4
          implicitHeight: iconUptime.implicitSize
          implicitWidth: iconUptime.implicitSize + textUptime.width + 4
          IconImage {
            id: iconUptime
            implicitSize: 16
            source: Quickshell.iconPath("smallclock-symbolic")
          }
          Rectangle {
            color: "transparent"
            implicitHeight: iconUptime.implicitHeight
            implicitWidth: textUptime.width
            Text {
              id: textUptime
              anchors.centerIn: parent
              color: Theme.ccTextColour
              font.family: Variables.fontFamilyTextCC
              font.pointSize: Variables.fontSizeText
              text: {
                let uptimeStr = root.uptime.trim();
                let uptime = uptimeStr.split(":");
                if (uptime.length === 1) {
                  let minutesLen = uptime[0].length;
                  return `00:${"0".repeat(2 - minutesLen)}${uptime[0]}`;
                }
                return uptimeStr;
              }
            }
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
  Timer {
    id: uptimeTimer
    interval: 60000
    running: true
    repeat: true
    onTriggered: userInfoUptime.running = true
  }
  Process {
    id: userInfoUptime
    command: ["sh", "-c", "uptime | awk '{print $3}' | cut -d ',' -f 1"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: function () {
        root.uptime = this.text;
      }
    }
  }
}
