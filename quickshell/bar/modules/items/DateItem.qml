import Quickshell
import QtQuick
import "../../../"

Item {
  id: root
  height: dateTimeRow.height
  width: dateTimeRow.width

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Row {
    id: dateTimeRow
    height: dateText.height
    width: dateText.width + timeText.width
    Text {
      id: dateText
      text: Qt.locale("de_DE").toString(clock.date, "ddd dd.MM.yy")
      color: Theme.get.dateColour
      font.pointSize: Variables.fontSizeText
      font.family: Variables.fontFamilyText
    }
    Text {
      id: timeText
      text: Qt.formatDateTime(clock.date, "·hh:mm:ss")
      color: Theme.get.timeColour
      font.pointSize: Variables.fontSizeText
      font.family: Variables.fontFamilyText
    }
  }
}
