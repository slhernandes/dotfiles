import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs
import qs.bar

Item {
  id: root
  width: Math.ceil(currentWindowRow.width)
  property list<var> rewrites: [
    {
      regex: /[kK]itty - (.*)/g,
      to: "1$",
      icon: Quickshell.iconPath("kitty")
    },
    {
      regex: /tmux - (.*)/g,
      to: "1$",
      icon: Quickshell.iconPath("tmux")
    },
    {
      regex: /(.*) [–—] Mozilla Firefox/g,
      to: "1$",
      clip: 20,
      icon: Quickshell.iconPath("firefox")
    },
    {
      regex: /(.*) [–—] Floorp/g,
      to: "1$",
      clip: 20,
      icon: Quickshell.iconPath("floorp")
    },
    {
      regex: /.* Discord \| (.*)/g,
      to: "1$",
      icon: Quickshell.iconPath("vesktop")
    },
    {
      regex: /\/*(.+\/)*(.+)\.pdf/g,
      to: "2$",
      clip: 20,
      icon: Quickshell.iconPath("org.pwmt.zathura")
    },
    {
      regex: /[sS]team/g,
      to: "Steam",
      icon: `file://${Variables.configDir}/icons/steam.png`
    }
  ]
  RowLayout {
    id: currentWindowRow
    spacing: 8
    height: parent.height
    width: {
      let totalWidth = windowIcon.implicitWidth + windowTitle.implicitWidth;
      if (totalWidth > 0) {
        totalWidth += 8;
      }
      return totalWidth;
    }
    IconImage {
      id: windowIcon
      implicitHeight: parent.height
      implicitWidth: windowTitle.text !== "" ? Variables.iconSize : 0
      source: {
        const replaceVar = /\d+\$(?!\$)/g;
        const winName = HyprlandUtils.currentActiveWindowTitle.toString();
        let defaultIcon = Quickshell.iconPath(HyprlandUtils.currentActiveWindowClass, true).toString();
        for (const re of root.rewrites) {
          const matches = winName.match(re.regex);
          if (matches !== null && re.icon !== undefined) {
            return re.icon;
          }
        }
        if (defaultIcon !== "") {
          return defaultIcon;
        }
        return `file://${Variables.configDir}/icons/unknown.png`;
      }
    }
    Text {
      id: windowTitle
      font {
        pointSize: Variables.fontSizeText
        family: Variables.fontFamilyText
      }
      text: {
        const replaceVar = /\d+\$(?!\$)/g;
        const winName = HyprlandUtils.currentActiveWindowTitle.toString();
        let ret = "";
        for (const re of root.rewrites) {
          const matches = winName.match(re.regex);
          console.log(matches);
          if (matches !== null) {
            ret = re.to.toString();
            let indices = ret.match(replaceVar);

            if (indices !== null) {
              for (const i of indices) {
                let idx = parseInt(i);
                ret = ret.replace(i, matches[idx]);
              }
            }
            if (re.clip !== undefined && ret.length > re.clip) {
              ret = ret.slice(0, parseInt(re.clip) - 1) + "…";
            }
            return ret;
          }
        }
        return winName;
      }
      color: Theme.windowTitleColour
    }
  }
}
