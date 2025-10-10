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

  function updateSun(sunrise: string, sunset: string) {
    sunPos.sunrise = sunrise;
    sunPos.sunset = sunset;
  }

  property bool controlCentreVisible: false
  property string monitorName: "eDP-1"

  property string sunrise: sunPos.sunrise
  property string sunset: sunPos.sunset

  property int activeNotifCount: 0
  property list<Notification> showedNotifs

  property string currentPopupName

  PersistentProperties {
    id: sunPos
    reloadableId: "sunPos"
    property string sunrise: ""
    property string sunset: ""
  }

  IpcHandler {
    target: "globalStates"
    function toggleControlCentre() {
      root.controlCentreVisible = !root.controlCentreVisible;
    }
  }
}
