import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "root:/"

RowLayout {
  property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

  Rectangle {
    id: workspaceBar

    // Layout.preferredWidth: 8 * 24 + 9 * 18 + (HyprlandUtils.getCurrentSpecialWorkspace().length > 0 ? 33 : 0)
    Layout.preferredWidth: workspacesRow.width
    Layout.preferredHeight: 32
    radius: 5
    color: Theme.get.barBgColour
    border {
      color: "#5b6078"
      width: 2
    }
    opacity: 0.85

    Row {
      id: workspacesRow

      property real repeaterWidth: 0

      anchors.centerIn: parent
      spacing: 0

      Repeater {
        id: normalWs
        model: 9
        WorkspaceElement {
          id: wsElem
        }

        onItemAdded: function (index, item) {
          workspacesRow.repeaterWidth += item.width;
        }
      }

      WorkspaceElement {
        id: specialWs
        index: -1
        onTextChanged: function () {
          workspacesRow.width = workspacesRow.repeaterWidth + specialWs.width;
        }
      }
    }
  }
}
