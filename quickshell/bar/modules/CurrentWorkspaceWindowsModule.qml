import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import qs.bar
import qs.bar.modules.items
import qs.bar.widgets

ModuleBlock {
  visible: windowIcons.model.length === 0 ? false : true
  RowLayout {
    id: windowRow
    spacing: 8
    Repeater {
      id: windowIcons
      signal windowAdded(windowClass: string, windowAddress: string)
      signal windowRemoved(windowAddress: string)

      function setModel() {
        let currentWorkspace = Hyprland.focusedWorkspace;
        if (HyprlandUtils.currentSpecialWorkspaceName !== "") {
          for (const w of HyprlandUtils.workspaces) {
            if (w.name == HyprlandUtils.currentSpecialWorkspaceName) {
              currentWorkspace = w;
              break;
            }
          }
          if (currentWorkspace.name != HyprlandUtils.currentSpecialWorkspaceName) {
            return [];
          }
        }
        getWindows.exec(["sh", "-c", `hyprctl clients -j | jq 'map(select(.workspace.name == "${currentWorkspace.name}"))'`]);
        let windows = JSON.parse(getWindows.windowInfo);
        let m = [];
        for (const w of windows) {
          let temp;
          if (w.class != "steam") {
            temp = {
              icon: Quickshell.iconPath(w.class),
              address: w.address
            };
          } else {
            temp = {
              icon: `file://${Variables.configDir}/icons/steam.png`,
              address: w.address
            };
          }
          m.push(temp);
        }
        return m;
      }

      model: setModel()
      CurrentWorkspaceWindowsItem {
        implicitHeight: parent.height
      }

      onWindowAdded: function (windowClass, windowAddress) {
        let icon = Quickshell.iconPath(windowClass);
        if (windowClass == "steam") {
          icon = `file://${Variables.configDir}/icons/steam.png`;
        }
        this.model.push({
          icon: icon,
          address: windowAddress
        });
      }

      onWindowRemoved: function (windowAddress) {
        let index = -1;
        for (let i = 0; i < this.model.length; i++) {
          if (this.model[i].address === windowAddress) {
            index = i;
            break;
          }
        }
        if (index !== -1) {
          this.model.splice(index, 1);
        }
      }
    }
    Connections {
      target: Hyprland
      function onRawEvent(event) {
        let args = event.data.split(",");
        switch (event.name) {
        case "openwindow":
          {
            windowIcons.windowAdded(args[2], `0x${args[0]}`);
            break;
          }
        case "closewindow":
          {
            windowIcons.windowRemoved(`0x${args[0]}`);
            break;
          }
        }
      }
    }
    Process {
      id: getWindows

      property string windowInfo

      running: false
      stdout: StdioCollector {
        waitForEnd: true
        onStreamFinished: function () {
          getWindows.windowInfo = this.text;
        }
      }
    }
  }
}
