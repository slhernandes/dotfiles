//@ pragma UseQApplication
import Quickshell
import qs.bar
import qs.controlCentre

Scope {
  Bar {}
  LazyLoader {
    loading: true
    ControlCentre {}
  }
}
