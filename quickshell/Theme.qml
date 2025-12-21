pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  PersistentProperties {
    id: themeProp
    reloadableId: "themeName"
    property string currentThemeName: "TokyoNightStorm.qml"
  }

  property Loader themeLoader: Loader {
    id: themeLoader
    source: `themes/${themeProp.currentThemeName}`
  }
  property ThemeItem theme: themeLoader.item as ThemeItem

  property string barBgColour: theme.background
  property string borderColour: theme.brightBlack

  property string workspaceActive: theme.magenta
  property string workspaceFilled: theme.foreground
  property string workspaceEmpty: theme.brightBlack
  property string workspaceHovered: theme.blue

  // property string logoColour: "#1793d0" // classic arch linux logo colour
  property string logoColour: theme.blue
  property string timeColour: theme.blue
  property string dateColour: theme.yellow
  property string windowTitleColour: theme.foreground

  property string inactiveElement: theme.brightBlack
  property string activeElement: theme.blue
  property string activeBorder: theme.blue

  property string batteryIndicatorCharging: theme.green
  property string batteryIndicatorNormal: theme.blue
  property string batteryIndicatorLow: theme.red

  property string ccTextColour: theme.white
  property string tooltipColour: theme.white

  property string osdBarColourBg: theme.brightBlack
  property string osdBarColour: theme.white

  property string pageIndicatorActive: theme.white
  property string pageIndicatorInactive: theme.brightBlack

  property string notifCritical: theme.brightYellow
  property string notifNormal: theme.background

  property string notifTextCritical: theme.brightBlack
  property string notifTextNormal: theme.white

  IpcHandler {
    target: "themeLoader"
    function getTheme(): string {
      return themeLoader.source;
    }
    function setTheme(s: string): bool {
      const old_theme = themeLoader.source;
      themeLoader.source = s + `?${Math.random()}`;
      if (themeLoader.status === Loader.Null || themeLoader.status === Loader.Error) {
        themeLoader.source = old_theme;
        return false;
      }
      return true;
    }
  }
}
