import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs

MouseArea {
  id: delegate
  required property SystemTrayItem modelData
  property alias item: delegate.modelData

  height: iconImage.implicitSize
  width: iconImage.implicitSize + 10

  acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
  hoverEnabled: true

  onClicked: event => {
    switch (event.button) {
    case Qt.LeftButton:
      {
        item.activate();
      }
      break;
    case Qt.MiddleButton:
      {
        item.secondaryActivate();
      }
      break;
    case Qt.RightButton:
      {
        menuAnchor.open();
      }
      break;
    }
  }

  onWheel: event => {
    event.accepted = true;
    const points = event.angleDelta.y / 120;
    item.scroll(points, false);
  }

  IconImage {
    id: iconImage
    anchors.centerIn: parent
    source: {
      let icon = parent.item.icon;
      if (icon.includes("?path=")) {
        const [name, path] = icon.split("?path=");
        icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
      }
      return icon;
    }
    implicitSize: Variables.iconSize
  }

  QsMenuAnchor {
    id: menuAnchor
    menu: delegate.item.menu

    anchor.window: delegate.QsWindow.window
    anchor.adjustment: PopupAdjustment.Flip | PopupAdjustment.Resize
    anchor.margins.top: 4

    anchor.onAnchoring: {
      const window = delegate.QsWindow.window;
      const widgetRect = window.contentItem.mapFromItem(delegate, 0, delegate.height, delegate.width, delegate.height);
      menuAnchor.anchor.rect = widgetRect;
    }
  }
}
