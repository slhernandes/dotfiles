import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import qs
import qs.bar
import qs.bar.modules.items
import qs.bar.widgets

ModuleBlock {
  visible: !windowIcons.model?.length ? false : true
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
        getWindows.exec(["sh", "-c", `hyprctl clients -j | jq -r 'map(select(.workspace.name == "${currentWorkspace?.name || ""}"))'`]);
        let windows = JSON.parse(getWindows.windowInfo.trim() || "[]");
        let m = [];
        for (const w of windows) {
          let temp;
          if (w.class != "steam") {
            let icon = Quickshell.iconPath(w.class, true);
            if (icon === "") {
              icon = `file://${Variables.configDir}/icons/unknown.png`;
            }
            temp = {
              icon: icon,
              address: w.address
            };
            // console.log(temp.icon);
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
        let icon = Quickshell.iconPath(windowClass, true) || `file://${Variables.configDir}/icons/unknown.png`;
        if (windowClass === "steam") {
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
            if (HyprlandUtils.currentSpecialWorkspaceName === args[1] || Hyprland.focusedWorkspace?.name === args[1]) {
              windowIcons.windowAdded(args[2], `0x${args[0]}`);
            }
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
