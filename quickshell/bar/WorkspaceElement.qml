import QtQuick
import Quickshell.Hyprland
import "root:/"

Item {
  id: root

  required property int index
  property list<string> workspaceNames: ["", "", "", "󱔘", "", "󱔘", "󰓓", "󰊗", "󰙯"]

  width: workspaceText.width
  height: workspaceText.height

  Text {
    id: workspaceText

    horizontalAlignment: Text.AlignHCenter
    padding: this.text.length > 0 ? 12 : 0
    text: root.index >= 0 ? root.workspaceNames[root.index] : ""
    color: mouseArea.containsMouse ? Theme.get.workspaceHovered : HyprlandUtils.getWorkspaceColour(root.index)
    font.pointSize: 15.8
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      HyprlandUtils.switchWorkspace(index + 1);
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      let eventName = event.name;
      switch (eventName) {
      case "activespecialv2":
        {
          if (root.index < 0) {
            const wsIndex = parseInt(event.data.split(",")[0]);
            const wsName = event.data.split(",")[1];
            root.index = isNaN(wsIndex) ? -1 : wsIndex;
            workspaceText.text = HyprlandUtils.getSpecialWorkspaceIcon(wsName);
            workspaceText.padding = workspaceText.text.length > 0 ? 12 : 0;
            root.width = workspaceText.width;
            root.textChanged();
          }
        }
      }
    }
  }

  signal textChanged
}
