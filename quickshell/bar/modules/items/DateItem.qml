import Quickshell
import QtQuick
import QtQuick.Layouts

import qs

Item {
  id: root
  width: dateTimeRow.width + anchors.rightMargin

  RowLayout {
    id: dateTimeRow
    height: parent.height
    anchors.centerIn: parent
    spacing: 0
    Text {
      id: dateText
      Layout.alignment: Qt.AlignVCenter
      text: {
        const locale = Qt.locale("de_DE");
        const dayName = locale.toString(Clock.date, "ddd");
        const date = locale.toString(Clock.date, "dd.MM.yy");
        return dayName + date;
      }
      color: Theme.dateColour
      font.pointSize: Variables.fontSizeText
      font.family: Variables.fontFamilyText
    }
    Text {
      id: timeText
      Layout.alignment: Qt.AlignVCenter
      text: Qt.formatDateTime(Clock.date, "·hh:mm:ss")
      color: Theme.timeColour
      font.pointSize: Variables.fontSizeText
      font.family: Variables.fontFamilyText
    }
  }
}
