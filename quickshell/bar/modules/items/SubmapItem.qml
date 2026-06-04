import Quickshell.Hyprland
import QtQuick

import qs

Item {
  id: root
  width: submapText.width
  property string submap: "NORMAL"

  Text {
    id: submapText
    text: {
      if (root.submap == "NORMAL") {
        return "\uE587";
      } else if (root.submap == "RESIZE") {
        return "\uF707";
      } else if (root.submap == "DROPDOWN") {
        return "\uF732";
      } else if (root.submap == "PASSTHROUGH") {
        return "\uF492";
      }
    }
    height: root.height
    verticalAlignment: Text.AlignVCenter
    color: {
      if (root.submap == "NORMAL") {
        return Theme.submapTextNormal;
      }
      return Theme.submapTextOther;
    }
    font.pointSize: Variables.fontSizeText
    font.family: Variables.fontFamilyTextIcons
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event.name == "submap") {
        const submapName = event.parse(1)[0];
        if (submapName == "") {
          root.submap = "NORMAL";
        } else {
          root.submap = submapName;
        }
      }
    }
  }
}
