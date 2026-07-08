pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
  id: root
  property string placeholderText: "Theme picker"
  property bool showIcons: false
  property real widthMult: 0.5
  property real heightMult: 0.38
  // property int elideMode: Text.ElideRight
  property var items: []

  Process {
    id: lsProc
    running: true
    command: ["ls", `${Variables.configDir}/themes`]
    stdout: StdioCollector {
      onStreamFinished: () => {
        root.items = this.text.trim().split("\n").map(x => {
          return {
            "filename": x,
            "name": x.split(".")[0] || x,
            "icon": null
          };
        });
      }
    }
  }

  function updateItems() {
    lsProc.running = true;
  }

  function execute(item: var) {
    if (!item) {
      return;
    }
    Theme.setTheme(item.filename);
    return;
  }

  function filter(inputText: string): list<var> {
    let filteredItems = [];
    for (const i of root.items) {
      if (i.name.toLowerCase().includes(inputText.toLowerCase())) {
        filteredItems.push(i);
      }
    }
    // console.log(root.items);
    // console.log(filteredItems);
    return filteredItems;
  }
}
