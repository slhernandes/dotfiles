import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs
import qs.controlCentre.modules

Scope {
  id: root
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      required property var modelData
      screen: modelData

      color: "transparent"

      Rectangle {
        color: Theme.barBgColour
        radius: Variables.radius
        border.width: Variables.borderWidth
        border.color: Theme.borderColour
        anchors.fill: parent
        opacity: Variables.barOpacity
      }

      anchors {
        top: true
        left: true
      }

      margins {
        top: 4
        left: 4
      }

      implicitWidth: 300
      implicitHeight: 300

      visible: GlobalStates.controlCentreVisible

      UserInfo {}

      Component.onCompleted: {
        if (this.WlrLayershell != null) {
          this.WlrLayershell.layer = WlrLayer.Top;
        }
      }
    }
  }
}
