pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
  id: root
  property string placeholderText: "Password"
  property bool showIcons: false
  property real widthMult: 1.0
  property int elideMode: Text.ElideRight
  property var items: []

  Process {
    id: fdProc
    running: true
    command: ["sh", "-c", "fd . -e gpg"]
    workingDirectory: Quickshell.env("PASSWORD_STORE_DIR") || `${Quickshell.env("HOME")}/.password-store`
    stdout: StdioCollector {
      onStreamFinished: () => {
        const lines = this.text.trim().split("\n");
        root.items = lines.map(x => {
          const path = x.split(".")[0];
          let name = x.split("/");
          name = name[name.length - 1];
          return {
            "name": path,
            "otp": name === "otp",
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
    let command = ["sh", "-c", `${Variables.configDir}/scripts/getPass.sh ${item.otp ? "otp" : "show"} ${item.name}`];
    Quickshell.execDetached({
      "command": command,
      "environment": {},
      "clearEnvironment": false
    });
    return;
  }

  // optional
  function execute_alt(item: var, inputText: string) {
    return;
  }

  function filter(inputText: string): list<var> {
    let filteredItems = [];
    for (const i of root.items) {
      if (i.name.toLowerCase().includes(inputText.toLowerCase())) {
        filteredItems.push(i);
      }
    }
    return filteredItems;
  }
}
