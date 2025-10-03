pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire

Singleton {

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  property bool controlCentreVisible: false
}
