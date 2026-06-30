pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
  id: root

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource].concat(Pipewire.linkGroups.values.filter(x => x.source.isStream).map(x => x.source))
  }

  PersistentProperties {
    id: dndStatus
    reloadableId: "dndStatus"
    property bool dndEnabled: false
  }

  enum Overlay {
    None = 0,
    ControlCentre = 1,
    NotifCentre = 2,
    Launcher = 3,
    Minimize = 4
  }

  property int currentOverlay: GlobalStates.Overlay.None
  property string launcherPosition: "center"
  property int minimizedCount: 0
  property bool dndEnabled: dndStatus.dndEnabled
  property string monitorName: "eDP-1"

  property string currentPopupName
  Process {
    id: minimizeNotif
    running: false
    command: ["sh", "-c", `notify-send -r 818 -u low -i ${Quickshell.shellDir}/icons/dialog-warning.svg "Minimizer" "No minimized window" -h string:x-canonical-private-synchronous:minimize -h boolean:dnd-bypass:true -h int:transient:1`]
  }
  IpcHandler {
    target: "globalStates"
    function toggleControlCentre(): bool {
      if (root.currentOverlay === GlobalStates.Overlay.ControlCentre) {
        root.currentOverlay = GlobalStates.Overlay.None;
      } else {
        root.currentOverlay = GlobalStates.Overlay.ControlCentre;
      }
      return root.currentOverlay === GlobalStates.Overlay.ControlCentre;
    }
    function toggleNotificationCentre(): bool {
      if (root.currentOverlay === GlobalStates.Overlay.NotifCentre) {
        root.currentOverlay = GlobalStates.Overlay.None;
      } else {
        root.currentOverlay = GlobalStates.Overlay.NotifCentre;
      }
      return root.currentOverlay === GlobalStates.Overlay.NotifCentre;
    }

    function toggleLauncher(position: string): bool {
      if (root.currentOverlay === GlobalStates.Overlay.Launcher) {
        root.currentOverlay = GlobalStates.Overlay.None;
      } else {
        root.currentOverlay = GlobalStates.Overlay.Launcher;
        root.launcherPosition = position;
      }
      return root.currentOverlay === GlobalStates.Overlay.Launcher;
    }

    function toggleMinimize(): bool {
      if (root.currentOverlay === GlobalStates.Overlay.Minimize) {
        root.currentOverlay = GlobalStates.Overlay.None;
      } else if (root.minimizedCount <= 0) {
        minimizeNotif.running = true;
      } else {
        root.currentOverlay = GlobalStates.Overlay.Minimize;
      }
      return root.currentOverlay === GlobalStates.Overlay.Minimize;
    }

    function toggleDnd() {
      dndStatus.dndEnabled = !dndStatus.dndEnabled;
    }
    function dndState(): bool {
      return dndStatus.dndEnabled;
    }
  }
}
