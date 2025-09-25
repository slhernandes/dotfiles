import QtQuick
import Quickshell.Services.UPower

import qs
import qs.bar.widgets

Item {
  id: root
  width: batteryIndicator.width

  Rectangle {
    width: batteryIndicator.width
    height: root.height
    color: "transparent"
    ClippedProgressBar {
      id: batteryIndicator
      anchors.centerIn: parent
      highlightColor: {
        const device = UPower.displayDevice;
        if (device.state == UPowerDeviceState.Charging) {
          return Theme.get.batteryIndicatorCharging;
        } else if (device.percentage <= .2) {
          return Theme.get.batteryIndicatorLow;
        }
        return Theme.get.batteryIndicatorNormal;
      }
      text: {
        let state = "󰁹";
        const device = UPower.displayDevice;
        if (device.state == UPowerDeviceState.Charging) {
          state = "󱐋";
        }
        const value = device.percentage * 100;
        let value_string = value.toString();
        value_string = " ".repeat(Math.max(0, 3 - value_string.length)) + value_string;
        return `${state}${value_string}`;
      }
      value: UPower.displayDevice.percentage
    }
  }
}
