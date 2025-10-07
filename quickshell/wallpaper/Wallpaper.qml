import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs

Scope {
  id: root
  PanelWindow {
    id: wallpaper

    function changeWallpaper(wallName: string) {
      currentWallpaper.wallName = wallName;
      image.y = wallpaper.screen.height;
    }

    PersistentProperties {
      id: currentWallpaper
      reloadableId: "wallpaper"
      property string wallName: "night_street"
    }

    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    mask: Region {}

    Image {
      id: image
      source: `file://${Variables.wallDir}/${currentWallpaper.wallName}.png`
      Behavior on y {
        NumberAnimation {
          duration: 10
          easing.type: Easing.InOutQuad
        }
      }
      onYChanged: function () {
        if (image.y === 0)
          return;
        if (image.y < 0) {
          image.y = 0;
          return;
        }
        image.y -= image.y / 4;
      }
    }

    IpcHandler {
      target: "wallpaper"
      function changeWallpaper(wallName: string) {
        wallpaper.changeWallpaper(wallName);
      }
    }

    Timer {
      id: wallpaperTimer
      running: true
      repeat: true
      triggeredOnStart: true
      interval: 60000
      onTriggered: function () {
        const cur = Math.round(Date.now() / 1000);
        const today = new Date();
        const sunrise = parseInt(GlobalStates.sunrise) || Math.round(today.setHours(6, 0, 0, 0) / 1000);
        const sunset = parseInt(GlobalStates.sunset) || Math.round(today.setHours(18, 0, 0, 0) / 1000);
        const wall = currentWallpaper.wallName.split("_");
        const pref = cur < sunrise || cur > sunset ? "night" : "day";
        if (pref !== wall[0]) {
          console.log("changing wallpaper");
          wallpaper.changeWallpaper(`${pref}_${wall[1]}`);
        }
      }
    }

    Component.onCompleted: {
      this.WlrLayershell.layer = WlrLayer.Background;
      this.WlrLayershell.namespace = "qsWallpaper";
    }
  }
}
