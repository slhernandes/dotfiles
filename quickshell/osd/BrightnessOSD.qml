pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

import qs

Scope {
  id: root

  property bool shouldShowOsd: false
  property string brightness
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
              let icon = "brightness_low.png";
              if (parseInt(root.brightness) > 66) {
                icon = "brightness_high.png";
              } else if (parseInt(root.brightness) > 33) {
                icon = "brightness_mid.png";
              }
              return `file://${Variables.configDir}/icons/${icon}`;
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
                let brightness = parseInt(root.brightness) / 100;
                return parent.width * brightness;
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
    target: "brightnessOSD"
    function openOSD(brightness: string) {
      root.shouldShowOsd = true;
      root.brightness = brightness;
      hideTimer.restart();
    }
  }
}
