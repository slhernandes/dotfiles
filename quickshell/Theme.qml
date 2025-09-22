pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property Item get: test

  Item {
    id: test

    property string barBgColour: "#24273a"
    property string workspaceActive: "#f5bde6"
    property string workspaceFilled: "#cad3f5"
    property string workspaceEmpty: "#5b6078"
    property string workspaceHovered: "#8aadf4"
    property string logoColour: "#1793d0"
  }
}
