pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs
import qs.controlCentre.widgets

CCModuleBlock {
  id: root
  required property real cellSize
  required property real moduleGap
  implicitWidth: root.cellSize * 3 + root.moduleGap * 2
  implicitHeight: root.cellSize * 2 + root.moduleGap
  ColumnLayout {
    anchors.centerIn: parent
    Text {
      Layout.alignment: Qt.AlignCenter
      color: Theme.ccTextColour
      text: {
        const locale = Qt.locale("de_DE");
        const date = locale.toString(Clock.date, "MMMM yyyy");
        return date;
      }
    }
    DayOfWeekRow {
      locale: Qt.locale("de_DE")
      Layout.fillWidth: true
      implicitHeight: 20
      spacing: 0
      delegate: Text {
        required property var model
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: model.shortName
        font.bold: true
        color: Theme.ccTextColour
      }
    }
    MonthGrid {
      id: monthGrid
      Layout.fillWidth: true
      spacing: 0
      delegate: Rectangle {
        id: monthGridRect
        required property var model
        implicitHeight: monthGridText.height
        implicitWidth: monthGridText.width * 2.5
        color: "transparent"
        Rectangle {
          anchors.centerIn: parent
          implicitHeight: monthGridText.height
          implicitWidth: monthGridText.height
          radius: 999
          color: {
            if (monthGridRect.model.day === parseInt(Qt.formatDate(Clock.date, "d")) && monthGridRect.model.month === monthGrid.month) {
              return Theme.activeElement;
            }
            return "transparent";
          }
        }
        Text {
          id: monthGridText
          text: monthGrid.locale.toString(monthGridRect.model.date, "d")
          anchors.centerIn: parent
          font.pointSize: 10
          color: {
            if (monthGridRect.model.month !== monthGrid.month) {
              return Theme.inactiveElement;
            } else if (monthGridRect.model.day === parseInt(Qt.formatDate(Clock.date, "d"))) {
              return Theme.barBgColour;
            }
            return Theme.ccTextColour;
          }
        }
      }
    }
  }
}
