pragma Singleton
import Quickshell

Singleton {
  property var date: clock.date
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
