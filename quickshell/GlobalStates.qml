pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
  id: root

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  property bool controlCentreVisible: false
  IpcHandler {
    target: "globalStates"
    function toggleControlCentre() {
      root.controlCentreVisible = !root.controlCentreVisible;
    }
  }
}
