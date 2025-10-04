pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets

import qs

Scope {
  id: root

  Connections {
    target: Pipewire.defaultAudioSink?.audio

    function onVolumeChanged() {
      root.shouldShowOsd = true && !GlobalStates.controlCentreVisible;
      root.isSink = true;
      hideTimer.restart();
    }

    function onMutedChanged() {
      root.shouldShowOsd = true && !GlobalStates.controlCentreVisible;
      root.isSink = true;
      hideTimer.restart();
    }
  }

  Connections {
    target: Pipewire.defaultAudioSource?.audio

    function onVolumeChanged() {
      root.shouldShowOsd = true && !GlobalStates.controlCentreVisible;
      root.isSink = false;
      hideTimer.restart();
    }

    function onMutedChanged() {
      root.shouldShowOsd = true && !GlobalStates.controlCentreVisible;
      root.isSink = false;
      hideTimer.restart();
    }
  }

  property bool shouldShowOsd: false
  property bool isSink: true

  Timer {
    id: hideTimer
    interval: 1000
    onTriggered: root.shouldShowOsd = false
  }

  // The OSD window will be created and destroyed based on shouldShowOsd.
  // PanelWindow.visible could be set instead of using a loader, but using
  // a loader will reduce the memory overhead when the window isn't open.
  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      // Since the panel's screen is unset, it will be picked by the compositor
      // when the window is created. Most compositors pick the current active monitor.

      anchors.top: true
      anchors.right: true
      margins.top: 4
      margins.right: 4
      exclusiveZone: 0

      implicitWidth: 400
      implicitHeight: 50
      color: "transparent"

      // An empty click mask prevents the window from blocking mouse events.
      mask: Region {}

      Rectangle {
        anchors.fill: parent
        radius: 5
        color: Theme.barBgColour
        border {
          width: 2
          color: Theme.activeBorder
        }
        opacity: Variables.barOpacity

        RowLayout {
          anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 15
          }

          IconImage {
            implicitSize: 30
            source: {
              if (root.isSink) {
                const default_sink = Pipewire.defaultAudioSink;
                let icon_name = "volume_low.svg";
                if (!!default_sink) {
                  if (default_sink?.audio.muted) {
                    icon_name = "volume_mute.svg";
                  } else {
                    if (default_sink?.audio.volume >= .5) {
                      icon_name = "volume_high.svg";
                    } else if (default_sink.audio.volume == 0) {
                      icon_name = "volume_mute.svg";
                    } else {
                      icon_name = "volume_low.svg";
                    }
                  }
                }
                return `file://${Variables.configDir}/icons/${icon_name}`;
              } else {
                const default_source = Pipewire.defaultAudioSource;
                let icon_name = "mic_on.png";
                if (default_source?.audio.muted) {
                  icon_name = "mic_off.png";
                }
                return `file://${Variables.configDir}/icons/${icon_name}`;
              }
            }
          }

          Rectangle {
            // Stretches to fill all left-over space
            Layout.fillWidth: true

            implicitHeight: 10
            radius: 20
            color: Theme.osdBarColourBg

            Rectangle {
              anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
              }
              color: Theme.osdBarColour

              implicitWidth: {
                let volume = root.isSink ? (Pipewire.defaultAudioSink?.audio.volume ?? 0) : (Pipewire.defaultAudioSource?.audio.volume ?? 0);
                return parent.width * volume;
              }
              radius: parent.radius
            }
          }
        }
      }

      Component.onCompleted: {
        this.WlrLayershell.layer = WlrLayer.Overlay;
        this.WlrLayershell.namespace = "qsVolumeOSD";
      }
    }
  }
  IpcHandler {
    target: "volumeOSD"
    function openOSD(isSink: bool) {
      root.isSink = isSink;
      root.shouldShowOsd = true && !GlobalStates.controlCentreVisible;
      hideTimer.restart();
    }
  }
}
