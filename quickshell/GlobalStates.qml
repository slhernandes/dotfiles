pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
  id: root

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  function updateSun(sunrise: string, sunset: string) {
    sunPos.sunrise = sunrise;
    sunPos.sunset = sunset;
  }

  property bool controlCentreVisible: false
  property string sunrise: sunPos.sunrise
  property string sunset: sunPos.sunset

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
