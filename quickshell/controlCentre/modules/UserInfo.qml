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
