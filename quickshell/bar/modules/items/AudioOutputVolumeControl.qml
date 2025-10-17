pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQml

import qs
import qs.bar.widgets

Scope {
  id: root
  required property Item parentItem
  property real sliderLength: 300
  property list<PwNode> nodes: Pipewire.linkGroups.values.filter(x => x.source.isStream).map(x => x.source)
  property bool audioPopupIsActive: false
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
      id: audioPopupMouse
      hoverEnabled: true
      width: content.width
      height: content.height
      Rectangle {
        id: content
        color: Theme.barBgColour
        opacity: 0
        radius: Variables.radius
        width: volumeElements.implicitWidth
        height: volumeElements.implicitHeight
        border {
          color: Theme.activeBorder
          width: 2
        }
        ColumnLayout {
          anchors.centerIn: parent
          Repeater {
            id: volumeElements
            model: root.nodes
            RowLayout {
              id: volumeRow
              required property PwNode modelData
              implicitWidth: audioDataIcon.implicitSize + audioDataMouseArea.implicitWidth
              implicitHeight: audioDataIcon.implicitSize + audioDataMouseArea.implicitHeight
              IconImage {
                id: audioDataIcon
                source: {
                  let iconName = volumeRow.modelData.properties["application.icon-name"];
                  let altIconName = volumeRow.modelData.properties["application.name"]?.toLowerCase();
                  let fallbackIcon = `file://${Variables.configDir}/icons/unknown.png`;
                  return Quickshell.iconPath(iconName, true) || Quickshell.iconPath(altIconName, true) || fallbackIcon;
                }
                implicitSize: audioData.valueBarHeight * 1.5
              }
              MouseArea {
                id: audioDataMouseArea
                implicitWidth: audioData.implicitWidth
                implicitHeight: audioData.implicitHeight
                acceptedButtons: Qt.LeftButton
                ClippedProgressBar {
                  id: audioData
                  implicitWidth: root.sliderLength
                  highlightColor: Theme.activeElement
                  value: volumeRow.modelData?.audio?.volume || 0.0
                  Rectangle {
                    color: "transparent"
                    width: audioData.implicitWidth
                    height: audioData.valueBarHeight
                    Text {
                      anchors.verticalCenter: parent.verticalCenter
                      anchors.left: parent.left
                      anchors.leftMargin: 5
                      text: volumeRow.modelData?.properties["media.name"] || volumeRow.modelData?.nickname || "Unknown source"
                      font.pixelSize: Variables.fontSizeText
                      elide: Text.ElideMiddle
                      maximumLineCount: 1
                      width: audioData.implicitWidth - 10
                    }
                  }
                }
                function setVolumeInput(event) {
                  let xPos = event.x;
                  const maxPos = audioData.implicitWidth;
                  if (xPos < 0) {
                    xPos = 0;
                  } else if (xPos > maxPos) {
                    xPos = maxPos;
                  }
                  let volume = Math.round(xPos / maxPos * 100) / 100;
                  if (!!volumeRow.modelData) {
                    volumeRow.modelData.audio.volume = volume;
                  }
                }
                onPressed: event => setVolumeInput(event)
                onPositionChanged: event => setVolumeInput(event)
              }
            }
            function recalc() {
              if (volumeElements.count === 0) {
                return;
              }
              let width = volumeElements.itemAt(0).implicitWidth;
              let height = volumeElements.itemAt(0).implicitHeight;
              volumeElements.implicitWidth = width + 20;
              volumeElements.implicitHeight = height * count + 10 * (count + 1);
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
          root.audioPopupIsActive = false;
          root.deactivatePopup();
        }
      }
      onEntered: function () {
        hoverTimer.stop();
      }
      onExited: function () {
        hoverTimer.start();
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
    hoverTimer.start();
  }
  onDeactivatePopup: function () {
    content.opacity = 0;
    closeTimer.start();
  }
  onDeactivatePopupImmediate: function () {
    content.opacity = 0;
    popupWindow.visible = false;
  }
}
