pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import QtQml

import qs
import qs.bar.widgets

Scope {
  id: root
  required property Item parentItem
  property real sliderLength: 300
  property list<UPowerDevice> devices: UPower.devices.values.filter(x => x.model.length > 0)
  signal activatePopup
  signal deactivatePopup
  signal deactivatePopupImmediate
  PopupWindow {
    id: popupWindow
    anchor {
      item: root.parentItem
      rect.y: root.parentItem.height + 4
      rect.x: 0
    }
    visible: false
    implicitWidth: content.width
    implicitHeight: content.height
    color: "transparent"
    MouseArea {
      id: batteryPopupMouse
      hoverEnabled: true
      width: content.width
      height: content.height
      Rectangle {
        id: content
        color: Theme.barBgColour
        opacity: 0
        radius: Variables.radius
        width: batteryElements.implicitWidth
        height: batteryElements.implicitHeight
        border {
          color: Theme.activeBorder
          width: 2
        }
        ColumnLayout {
          anchors.centerIn: parent
          Repeater {
            id: batteryElements
            model: root.devices
            RowLayout {
              id: batteryRow
              required property UPowerDevice modelData
              implicitWidth: batteryDataIcon.implicitSize + batteryData.implicitWidth
              implicitHeight: batteryDataIcon.implicitSize + batteryData.valueBarHeight
              IconImage {
                id: batteryDataIcon
                source: {
                  let icons = [
                    {
                      device: "ASUS Battery",
                      icon: "computer-laptop-symbolic"
                    },
                    {
                      device: "Logitech G Pro",
                      icon: "input-mouse-battery-symbolic"
                    }
                  ];
                  let model = batteryRow.modelData.model;
                  for (const icon of icons) {
                    if (icon.device === model) {
                      return Quickshell.iconPath(icon.icon);
                    }
                  }
                  return Quickshell.iconPath("battery-missing-symbolic");
                }
                implicitSize: batteryData.valueBarHeight * 1.5
              }
              ClippedProgressBar {
                id: batteryData
                implicitWidth: root.sliderLength
                highlightColor: {
                  if (batteryRow.modelData.state === UPowerDeviceState.Charging || batteryRow.modelData.changeRate == 0) {
                    return Theme.batteryIndicatorCharging;
                  } else if (batteryRow.modelData.percentage <= .2) {
                    return Theme.batteryIndicatorLow;
                  }
                  return Theme.batteryIndicatorNormal;
                }
                value: batteryRow.modelData?.percentage || 0.0
                Rectangle {
                  color: "transparent"
                  width: batteryData.implicitWidth
                  height: batteryData.valueBarHeight
                  Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    text: batteryRow.modelData?.model
                    font.pixelSize: Variables.fontSizeText
                    elide: Text.ElideMiddle
                    maximumLineCount: 1
                    width: batteryData.implicitWidth - 10
                  }
                }
              }
            }
            function recalc() {
              if (batteryElements.count === 0) {
                return;
              }
              let width = batteryElements.itemAt(0).implicitWidth;
              let height = batteryElements.itemAt(0).implicitHeight;
              batteryElements.implicitWidth = width + 20;
              batteryElements.implicitHeight = height * count + 10 * (count + 1);
            }
            onItemAdded: () => recalc()
            onItemRemoved: () => recalc()
          }
        }
        Behavior on opacity {
          NumberAnimation {
            duration: 200
          }
        }
      }
      Timer {
        id: hoverTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: function () {
          root.deactivatePopup();
        }
      }
      onEntered: function () {
        hoverTimer.stop();
        console.log("entered");
      }
      onExited: function () {
        hoverTimer.start();
        console.log("exited");
      }
    }
  }
  Timer {
    id: closeTimer
    interval: 200
    running: false
    repeat: false
    onTriggered: function () {
      popupWindow.visible = false;
    }
  }
  onActivatePopup: function () {
    popupWindow.visible = true;
    content.opacity = Variables.barOpacity;
  }
  onDeactivatePopup: function () {
    content.opacity = 0;
    closeTimer.start();
  }
  onDeactivatePopupImmediate: function () {
    popupWindow.visible = false;
  }
}
