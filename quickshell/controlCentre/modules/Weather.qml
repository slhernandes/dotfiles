import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs
import qs.controlCentre.modules
import qs.controlCentre.widgets

CCModuleBlock {
  required property real cellSize
  required property real moduleGap

  RowLayout {
    Rectangle {
      implicitWidth: 100
      implicitHeight: 100
      color: "transparent"
      IconImage {
        id: weatherIcon
        anchors.centerIn: parent
        source: WeatherData.icon || `file://${Variables.configDir}/icons/cloud.png`
        implicitSize: 80
      }
    }
    ColumnLayout {
      Text {
        id: temperature
        font.pointSize: 18
        font.family: Variables.fontFamilyTextCC
        color: Theme.ccTextColour
        text: WeatherData.temperature
      }
      Text {
        id: city
        font.pointSize: 12
        font.family: Variables.fontFamilyTextCC
        color: Theme.ccTextColour
        text: WeatherData.city
      }
      Text {
        id: weatherDesc
        font.pointSize: 12
        font.family: Variables.fontFamilyTextCC
        color: Theme.ccTextColour
        text: WeatherData.weatherDesc
      }
    }
  }
}
