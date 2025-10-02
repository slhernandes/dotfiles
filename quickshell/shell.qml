//@ pragma UseQApplication
//@ pragma IconTheme breeze-dark
import Quickshell
import QtQuick
import qs.bar
import qs.controlCentre

Scope {
  Bar {}
  LazyLoader {
    loading: true
    ControlCentre {}
  }
}
