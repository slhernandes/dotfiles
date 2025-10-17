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

  property bool controlCentreVisible: false
  property string monitorName: "eDP-1"

  property int activeNotifCount: 0
  property list<Notification> showedNotifs

  property string currentPopupName
  IpcHandler {
    target: "globalStates"
    function toggleControlCentre() {
      root.controlCentreVisible = !root.controlCentreVisible;
    }
  }
}
