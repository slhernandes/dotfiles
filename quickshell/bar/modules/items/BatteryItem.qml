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
        width: icon.implicitWidth + content.width + 8
        spacing: 0
        IconImage {
          id: icon
          implicitHeight: content.height
          implicitWidth: content.height * 0.75
          Layout.alignment: Qt.AlignRight
          source: {
            let icon_name = "battery_full.svg";
            const device = UPower.displayDevice;
            if (device.state === UPowerDeviceState.Charging || device.changeRate == 0) {
              icon_name = "lightning.svg";
            } else {
              if (device.percentage <= .2) {
                icon_name = "battery_alert.svg";
              }
            }
            let dev = UPower.devices.values;
            return `file://${Variables.configDir}/icons/${icon_name}`;
          }
        }
        Text {
          id: content
          font {
            family: Variables.fontFamilyText
            pointSize: Variables.fontSizeSmall
          }
          Layout.alignment: Qt.AlignLeft
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
  MouseArea {
    width: batteryBox.width
    height: root.implicitHeight
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
