pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
  id: root
  property string placeholderText: "Pdf search (type +<dir> for dir filter)"
  property bool showIcons: false
  property real widthMult: 1.65
  property int elideMode: Text.ElideRight
  property var items: []

  Process {
    id: fdProc
    running: true
    command: ["sh", "-c", "fd . $HOME/Dokumente $HOME/Downloads -e pdf"]
    stdout: StdioCollector {
      onStreamFinished: () => {
        const lines = this.text.trim().split("\n");
        root.items = lines.map(x => {
          const path = x.split("/");
          let filename = path[path.length - 1];
          if (filename.length > 55) {
            filename = filename.slice(0, 51) + "….pdf";
          }
          return {
            "filename": filename,
            "dirlist": path.slice(0, path.length - 1),
            "name": `<b>${filename}</b>: ~/${path.slice(3, path.length - 1).join("/")}`,
            "icon": null
          };
        });
      }
    }
  }

  function updateItems() {
    fdProc.running = true;
  }

  function execute(item: var, inputText: string) {
    if (!item) {
      return;
    }
    Quickshell.execDetached({
      "command": [Variables.pdfReader, item.filename],
      "environment": {},
      "clearEnvironment": false,
      "workingDirectory": item.dirlist.join("/")
    });
    return;
  }

  function filter(inputText: string): list<var> {
    let filteredItems = [];
    const inputList = inputText.split(" ");
    for (const item of root.items) {
      let included = true;
      for (const i of inputList) {
        if (i.length <= 0) {
          continue;
        }
        if (i[0] === "+") {
          const dirname = i.slice(1).toLowerCase();
          let found = false;
          for (const dir of item.dirlist) {
            if (dir.toLowerCase().includes(dirname)) {
              found = true;
              break;
            }
          }
          if (!found) {
            included = false;
            break;
          }
        } else {
          if (!item.filename.toLowerCase().includes(i.toLowerCase())) {
            included = false;
            break;
          }
        }
      }
      if (included) {
        filteredItems.push(item);
      }
    }
    return filteredItems;
  }
}
