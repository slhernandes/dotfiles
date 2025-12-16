import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs
import qs.bar

Item {
  id: root

  visible: workspaceText.text.length > 0 ? true : false

  required property int modelData
  property list<string> workspaceNames: ["", "", "", "󱔘", "", "󱔘", "󰓓", "󰊗", "󰙯"]

  implicitWidth: Math.ceil(workspaceText.width)
  // implicitHeight: 32
  Layout.alignment: Qt.AlignCenter

  Text {
    id: workspaceText

    // verticalAlignment: Text.AlignBottom
    anchors.centerIn: parent
    bottomPadding: 10
    padding: this.text.length > 0 ? 8 : 0
    text: root.modelData >= 0 ? root.workspaceNames[root.modelData] : ""
    color: mouseArea.containsMouse ? Theme.workspaceHovered : HyprlandUtils.getWorkspaceColour(root.modelData)
    font.pixelSize: Variables.fontSizeWorkspaceIcon

    Behavior on color {
      ColorAnimation {
        duration: 200
      }
    }
  }

  MouseArea {
    id: mouseArea
    width: workspaceText.width
    height: workspaceText.height
    anchors.centerIn: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onClicked: {
      HyprlandUtils.switchWorkspace(root.modelData + 1);
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      let eventName = event.name;
      switch (eventName) {
      case "activespecialv2":
        {
          if (root.modelData < 0) {
            const wsmodelData = parseInt(event.data.split(",")[0]);
            const wsName = event.data.split(",")[1];
            root.modelData = isNaN(wsmodelData) ? -1 : wsmodelData;
            workspaceText.text = HyprlandUtils.getSpecialWorkspaceIcon(wsName);
            workspaceText.padding = workspaceText.text.length > 0 ? 6 : 0;
            root.visible = workspaceText.text.length > 0;
            root.width = workspaceText.width;
            root.textChanged();
          }
        }
      }
    }
  }

  signal textChanged
}
