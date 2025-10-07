pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs
import qs.controlCentre.modules

Scope {
  id: root
  PanelWindow {
    id: controlCentre
    property real cellSize: 100
    property real moduleGap: 8
    screen: {
      let screens = Quickshell.screens;
      for (const s of screens) {
        if (s.name === GlobalStates.monitorName) {
          return s;
        }
      }
      return Quickshell.screens[0];
    }

    color: "transparent"

    MouseArea {
      id: ccMouseArea
      anchors.fill: parent
      onClicked: function () {
        if (!ccBackground.contains(Qt.point(mouseX, mouseY - Variables.barHeight - 4))) {
          GlobalStates.controlCentreVisible = false;
        }
      }
    }

    Shortcut {
      sequence: "escape"
      onActivated: GlobalStates.controlCentreVisible = false
    }

    Shortcut {
      sequence: "Alt+M"
      onActivated: volumeControl.toggleMuteSink()
    }

    Shortcut {
      sequence: "Alt++"
      onActivated: volumeControl.volumeSinkUp()
    }

    Shortcut {
      sequence: "Alt+-"
      onActivated: volumeControl.volumeSinkDown()
    }

    Shortcut {
      sequence: "Alt+Shift+M"
      onActivated: volumeControl.toggleMuteSource()
    }

    Shortcut {
      sequence: "Alt+Shift++"
      onActivated: volumeControl.volumeSourceUp()
    }

    Shortcut {
      sequence: "Alt+Shift+-"
      onActivated: volumeControl.volumeSourceDown()
    }

    Shortcut {
      sequence: "Alt+H"
      onActivated: mediaPlayer.prevPlayer()
    }

    Shortcut {
      sequence: "Alt+L"
      onActivated: mediaPlayer.nextPlayer()
    }

    Shortcut {
      sequence: "Alt+J"
      onActivated: mediaPlayer.prevTrack()
    }

    Shortcut {
      sequence: "Alt+K"
      onActivated: mediaPlayer.nextTrack()
    }

    Shortcut {
      sequence: "Alt+Space"
      onActivated: mediaPlayer.togglePlay()
    }

    Shortcut {
      sequence: "Ctrl+Alt+1"
      onActivated: powerMenu.shutdown()
    }

    Shortcut {
      sequence: "Ctrl+Alt+2"
      onActivated: powerMenu.restart()
    }
    Shortcut {
      sequence: "Ctrl+Alt+3"
      onActivated: powerMenu.restartToWindows()
    }
    Shortcut {
      sequence: "Ctrl+Alt+4"
      onActivated: powerMenu.lock()
    }
    Shortcut {
      sequence: "Ctrl+Alt+5"
      onActivated: powerMenu.logout()
    }

    anchors {
      top: true
      left: true
      bottom: true
      right: true
    }

    margins.top: -Variables.barHeight
    margins.left: 4

    visible: GlobalStates.controlCentreVisible

    Rectangle {
      id: ccBackground
      color: Theme.inactiveElement
      border {
        width: 2
        color: Theme.activeBorder
      }
      anchors.top: parent.top
      anchors.topMargin: Variables.barHeight + 4
      radius: Variables.radius
      opacity: Variables.ccBgOpacity
      width: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
      height: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
      visible: true
    }
    Rectangle {
      color: "transparent"
      anchors.top: parent.top
      anchors.topMargin: Variables.barHeight + 4
      width: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
      height: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4 + 16
      ColumnLayout {
        id: controlCentreLayout
        anchors.centerIn: parent
        spacing: controlCentre.moduleGap
        RowLayout {
          spacing: controlCentre.moduleGap
          ColumnLayout {
            spacing: controlCentre.moduleGap
            UserInfo {
              implicitWidth: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
              implicitHeight: controlCentre.cellSize
              cellSize: controlCentre.cellSize
              moduleGap: controlCentre.moduleGap
            }
            Weather {
              implicitWidth: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
              implicitHeight: controlCentre.cellSize
              cellSize: controlCentre.cellSize
              moduleGap: controlCentre.moduleGap
            }
            Calendar {
              implicitWidth: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
              implicitHeight: controlCentre.cellSize * 2 + controlCentre.moduleGap
              cellSize: controlCentre.cellSize
              moduleGap: controlCentre.moduleGap
            }
          }
          ColumnLayout {
            spacing: controlCentre.moduleGap
            MediaPlayer {
              id: mediaPlayer
              implicitWidth: controlCentre.cellSize * 2 + controlCentre.moduleGap
              implicitHeight: controlCentre.cellSize * 3 + controlCentre.moduleGap * 2
              cellSize: controlCentre.cellSize
              moduleGap: controlCentre.moduleGap
            }
            VolumeControl {
              id: volumeControl
              implicitWidth: controlCentre.cellSize * 2 + controlCentre.moduleGap
              implicitHeight: controlCentre.cellSize
              cellSize: controlCentre.cellSize
              moduleGap: controlCentre.moduleGap
            }
          }
        }
        PowerMenu {
          id: powerMenu
          implicitWidth: controlCentre.cellSize * 5 + controlCentre.moduleGap * 4
          implicitHeight: controlCentre.cellSize
          cellSize: controlCentre.cellSize
          moduleGap: controlCentre.moduleGap
        }
      }
    }

    Component.onCompleted: {
      this.WlrLayershell.layer = WlrLayer.Overlay;
      this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
      this.WlrLayershell.namespace = "qsControlCentre";
    }
  }
}
