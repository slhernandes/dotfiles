import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs
import qs.controlCentre.widgets

CCModuleBlock {
  id: root
  required property real cellSize
  required property real moduleGap
  property real boxSize: 80
  RowLayout {
    anchors.centerIn: parent
    spacing: 28
    MouseArea {
      id: shutdownMouseArea
      hoverEnabled: true
      implicitHeight: root.boxSize
      implicitWidth: root.boxSize
      onClicked: function (event) {
        shutdownProcess.running = true;
      }
      Rectangle {
        anchors.centerIn: parent
        implicitHeight: root.boxSize
        implicitWidth: root.boxSize
	radius: 5
        color: shutdownMouseArea.containsMouse ? Theme.activeElement : Theme.inactiveElement
        Behavior on color {
          ColorAnimation {
            duration: 200
          }
        }
        IconImage {
          anchors.centerIn: parent
          implicitSize: 64
          source: `file://${Variables.configDir}/icons/power.png`
        }
      }
      Process {
        id: shutdownProcess
        running: false
        command: ["shutdown", "-h", "now"]
      }
    }
    MouseArea {
      id: restartMouseArea
      hoverEnabled: true
      implicitHeight: root.boxSize
      implicitWidth: root.boxSize
      onClicked: function (event) {
        restartProcess.running = true;
      }
      Rectangle {
        anchors.centerIn: parent
        implicitHeight: root.boxSize
        implicitWidth: root.boxSize
	radius: 5
        color: restartMouseArea.containsMouse ? Theme.activeElement : Theme.inactiveElement
        Behavior on color {
          ColorAnimation {
            duration: 200
          }
        }
        IconImage {
          anchors.centerIn: parent
          implicitSize: 64
          source: `file://${Variables.configDir}/icons/restart.png`
        }
      }
      Process {
        id: restartProcess
        running: false
        command: ["reboot"]
      }
    }
    MouseArea {
      id: rebootWindowsMouseArea
      hoverEnabled: true
      implicitHeight: root.boxSize
      implicitWidth: root.boxSize
      onClicked: function (event) {
        rebootWindowsProcess.running = true;
      }
      Rectangle {
        anchors.centerIn: parent
        implicitHeight: root.boxSize
        implicitWidth: root.boxSize
	radius: 5
        color: rebootWindowsMouseArea.containsMouse ? Theme.activeElement : Theme.inactiveElement
        Behavior on color {
          ColorAnimation {
            duration: 200
          }
        }
        IconImage {
          anchors.centerIn: parent
          implicitSize: 64
          source: `file://${Variables.configDir}/icons/windows.png`
        }
      }
      Process {
        id: rebootWindowsProcess
        running: false
        command: ["sh", "-c", "systemctl reboot --boot-loader-entry=$entry --boot-loader-menu=1"]
      }
    }
    MouseArea {
      id: lockMouseArea
      hoverEnabled: true
      implicitHeight: root.boxSize
      implicitWidth: root.boxSize
      onClicked: function (event) {
        lockProcess.running = true;
      }
      Rectangle {
        anchors.centerIn: parent
        implicitHeight: root.boxSize
        implicitWidth: root.boxSize
	radius: 5
        color: lockMouseArea.containsMouse ? Theme.activeElement : Theme.inactiveElement
        Behavior on color {
          ColorAnimation {
            duration: 200
          }
        }
        IconImage {
          anchors.centerIn: parent
          implicitSize: 64
          source: `file://${Variables.configDir}/icons/lock.png`
        }
      }
      Process {
        id: lockProcess
        running: false
        command: ["hyprlock"]
      }
    }
    MouseArea {
      id: logoutMouseArea
      hoverEnabled: true
      implicitHeight: root.boxSize
      implicitWidth: root.boxSize
      onClicked: function (event) {
        logoutProcess.running = true;
      }
      Rectangle {
        anchors.centerIn: parent
        implicitHeight: root.boxSize
        implicitWidth: root.boxSize
	radius: 5
        color: logoutMouseArea.containsMouse ? Theme.activeElement : Theme.inactiveElement
        Behavior on color {
          ColorAnimation {
            duration: 200
          }
        }
        IconImage {
          anchors.centerIn: parent
          implicitSize: 64
          source: `file://${Variables.configDir}/icons/logout.png`
        }
      }
      Process {
        id: logoutProcess
        running: false
        command: ["pkill", "-u", "samuelhernandes"]
      }
    }
  }
}
