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
      root.shouldShowOsd = true;
      root.isSink = true;
      hideTimer.restart();
    }

    function onMutedChanged() {
      root.shouldShowOsd = true;
      root.isSink = true;
      hideTimer.restart();
    }
  }

  Connections {
    target: Pipewire.defaultAudioSource?.audio

    function onVolumeChanged() {
      root.shouldShowOsd = true;
      root.isSink = false;
      hideTimer.restart();
    }

    function onMutedChanged() {
      root.shouldShowOsd = true;
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

          Text {
            text: {
              if (root.isSink) {
                const default_sink = Pipewire.defaultAudioSink;
                let icon = "\uE04D"; // volume low
                if (!!default_sink) {
                  if (default_sink?.audio.muted) {
                    icon = "\uE04F"; // volume off
                  } else {
                    if (default_sink?.audio.volume >= .5) {
                      icon = "\uE050"; // volume high
                    } else if (default_sink.audio.volume == 0) {
                      icon = "\uE04F"; // volume off
                    } else {
                      icon = "\uE04D"; // volume low
                    }
                  }
                }
                return icon;
              } else {
                const default_source = Pipewire.defaultAudioSource;
                let icon = "\uE029";
                if (default_source?.audio.muted) {
                  icon = "\uE02B";
                }
                return icon;
              }
            }
            font.pixelSize: Variables.fontSizeIconL
            font.family: Variables.fontFamilyTextIcons
            color: Theme.osdIconColour
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
      root.shouldShowOsd = true;
      hideTimer.restart();
    }
  }
}
