pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell.Widgets

import qs
import qs.bar.widgets

Item {
  id: root
  width: batteryIndicator.width
  property string popupName: "batteryPopup"

  Rectangle {
    id: batteryBox
    width: batteryIndicator.width
    height: root.height
    color: "transparent"
    ClippedProgressBar {
      id: batteryIndicator
      anchors.centerIn: parent
      width: batteryRow.width
      height: batteryRow.height
      highlightColor: {
        const device = UPower.displayDevice;
        if (device.state === UPowerDeviceState.Charging || device.changeRate == 0) {
          return Theme.batteryIndicatorCharging;
        } else if (device.percentage <= .2) {
          return Theme.batteryIndicatorLow;
        }
        return Theme.batteryIndicatorNormal;
      }
      value: UPower.displayDevice.percentage
      RowLayout {
        id: batteryRow
        width: content.width + icon.implicitWidth + Variables.progressBarPadding
        height: content.height
        spacing: 0
        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.preferredWidth: icon.width
          border.width: 0
          color: "transparent"
          Text {
            id: icon
            anchors.right: parent.right
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.Right
            text: {
              const battery_full = "\uE1A4";
              const charging = "\uE1A3";
              const battery_alert = "\uE19C";
              const device = UPower.displayDevice;
              if (device.state === UPowerDeviceState.Charging || device.changeRate == 0) {
                return charging;
              } else if (device.percentage <= .2) {
                return battery_alert;
              }
              return battery_full;
            }
            font.pixelSize: Variables.fontSizeIcon
            font.family: Variables.fontFamilyTextIcons
            color: Theme.progressBarColour
          }
        }
        Rectangle {
          color: "transparent"
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.preferredWidth: content.width
          border.width: 0
          Text {
            id: content
            color: Theme.progressBarColour
            font {
              family: Variables.fontFamilyText
              pointSize: Variables.fontSizeSmall
            }
            anchors.left: parent.left
            text: {
              const device = UPower.displayDevice;
              const value = Math.round(device.percentage * 100);
              let value_string = value.toString();
              value_string = " ".repeat(Math.max(0, 3 - value_string.length)) + value_string;
              return `${value_string}`;
            }
          }
        }
      }
    }
  }
  MouseArea {
    width: batteryBox.width
    height: root.implicitHeight
    cursorShape: Qt.PointingHandCursor
    onClicked: function (event) {
      batteryPopup.activatePopup();
      GlobalStates.currentPopupName = root.popupName;
    }
  }
  BatteryPopup {
    id: batteryPopup
    parentItem: batteryBox
  }
  Connections {
    target: GlobalStates
    function onCurrentPopupNameChanged() {
      if (GlobalStates.currentPopupName !== root.popupName) {
        batteryPopup.deactivatePopupImmediate();
      }
    }
  }
}
