pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

import qs

Singleton {
  id: hyprland

  property string currentSpecialWorkspaceName: ""
  property list<HyprlandWorkspace> workspaces: sortWorkspaces(Hyprland.workspaces.values)
  property int maxWorkspace: findMaxId()
  property string currentActiveWindowTitle
  property string currentActiveWindowClass

  function sortWorkspaces(ws) {
    return [...ws].sort((a, b) => a?.id - b?.id);
  }

  function switchWorkspace(w: int): void {
    Hyprland.dispatch(`workspace ${w}`);
  }

  function findMaxId(): int {
    if (hyprland.workspaces.length === 0) {
      return 1; // Return 1 if no workspaces exist
    }
    let num = hyprland.workspaces.length;
    let maxId = hyprland.workspaces[num - 1]?.id || 1;
    return maxId;
  }

  function getSpecialWorkspaceIcon(name): string {
    const iconMap = new Map([["special:magic", "󱀐"], ["special:minimized", ""], ["special:btop", ""], ["special:neomutt", ""], ["special:wezterm", ""], ["special:firefox", ""], ["special:ytermusic", ""], ["special:ferdium", "󰍡"], ["special:yazi", "󰇥"], ["special:ghostty", "󰊠"], ["special:ncmpcpp", ""]]);
    if (iconMap.has(name)) {
      return iconMap.get(name);
    }
    return "";
  }

  function getSpecialWorkspaceIconFromIndex(index): string {
    if (index >= 0) {
      return "";
    }
    var name = "";
    for (const ws of hyprland.workspaces) {
      if (index === ws.name) {
        name = ws.name;
      }
    }
    return getSpecialWorkspaceIcon(name);
  }

  function workspaceIsEmpty(index): bool {
    if (index < 0) {
      return false;
    }
    const checkId = index + 1;
    for (const ws of hyprland.workspaces) {
      if (ws?.id == checkId) {
        if (ws?.toplevels.values.length == 0) {
          return true;
        }
        return false;
      }
    }
    return true;
  }

  function workspaceIsFocused(index): bool {
    if (hyprland.currentSpecialWorkspaceName.length === 0) {
      return Hyprland.focusedWorkspace?.id === index + 1;
    }
    return index < 0;
  }

  function getWorkspaceColour(index): string {
    if (workspaceIsFocused(index)) {
      return Theme.workspaceActive;
    } else if (workspaceIsEmpty(index)) {
      return Theme.workspaceEmpty;
    }
    return Theme.workspaceFilled;
  }

  Process {
    id: updateActiveWindowClass
    running: false
    command: ["sh", "-c", "hyprctl activewindow -j | jq '.class'"]
    stdout: StdioCollector {
      onStreamFinished: {
        if (this.text.trim() === "null") {
          hyprland.currentActiveWindowClass = "";
        } else {
          hyprland.currentActiveWindowClass = this.text.replace(/\"/g, "").trim();
        }
      }
    }
  }

  Process {
    id: updateActiveWindowTitle
    running: false
    command: ["sh", "-c", "hyprctl activewindow -j | jq '.title'"]
    stdout: StdioCollector {
      onStreamFinished: {
        if (this.text.trim() === "null") {
          hyprland.currentActiveWindowTitle = "";
        } else {
          hyprland.currentActiveWindowTitle = this.text.replace(/\"/g, "").trim();
        }
      }
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      let eventName = event.name;

      switch (eventName) {
      case "createworkspacev2":
        {
          hyprland.workspaces = hyprland.sortWorkspaces(Hyprland.workspaces.values);
          hyprland.maxWorkspace = findMaxId();
          break;
        }
      case "destroyworkspacev2":
        {
          hyprland.workspaces = hyprland.sortWorkspaces(Hyprland.workspaces.values);
          hyprland.maxWorkspace = findMaxId();
          break;
        }
      case "activespecialv2":
        {
          hyprland.currentSpecialWorkspaceName = event.data.split(",")[1];
          break;
        }
      case "workspacev2":
        {
          break;
        }
      }
      updateActiveWindowTitle.running = true;
      updateActiveWindowClass.running = true;
    }
  }
}
