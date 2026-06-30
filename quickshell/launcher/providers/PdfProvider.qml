pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
  id: root
  property string placeholderText: "Pdf search"
  property bool showIcons: false
  property var items: [
    {
      "name": "/home/samuelhernandes/Dokumente/test/test.pdf",
      "icon": null
    }
  ]

  function execute(item: var) {
    // TODO: Add execute
    if (!item) {
      return;
    }
    return;
  }
}
