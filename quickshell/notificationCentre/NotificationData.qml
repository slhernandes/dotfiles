pragma Singleton
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root
  property int activeNotifCount: 0
  property list<Notification> showedNotifs: []
  NotificationServer {
    imageSupported: true
    actionsSupported: true
    onNotification: function (notification) {
      notification.tracked = true;
      root.activeNotifCount += 1;
      root.showedNotifs.push(notification);
    }
  }
}
