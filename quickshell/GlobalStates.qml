pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications

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

  property bool notifCentreVisible: false
  property bool controlCentreVisible: false
  property bool dndEnabled: dndStatus.dndEnabled
  property string monitorName: "eDP-1"

  property string currentPopupName
  IpcHandler {
    target: "globalStates"
    function toggleControlCentre() {
      if (root.controlCentreVisible) {
        root.controlCentreVisible = false;
      } else {
        root.controlCentreVisible = true;
        root.notifCentreVisible = false;
      }
    }
    function toggleNotificationCentre() {
      if (root.notifCentreVisible) {
        root.notifCentreVisible = false;
      } else {
        root.notifCentreVisible = true;
        root.controlCentreVisible = false;
      }
    }
    function toggleDnd() {
      dndStatus.dndEnabled = !dndStatus.dndEnabled;
    }
    function dndState(): bool {
      return dndStatus.dndEnabled;
    }
  }
}
