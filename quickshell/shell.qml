//@ pragma UseQApplication
//@ pragma IconTheme breeze-dark
import Quickshell

import qs.bar
import qs.controlCentre
import qs.osd
import qs.wallpaper
import qs.notificationCentre

Scope {
  Bar {}
  LazyLoader {
    loading: true
    ControlCentre {}
  }
  LazyLoader {
    loading: true
    VolumeOSD {}
  }
  LazyLoader {
    loading: true
    BrightnessOSD {}
  }
  Wallpaper {}
  // LazyLoader {
  //   loading: true
  //   NotificationCentre {}
  // }
}
