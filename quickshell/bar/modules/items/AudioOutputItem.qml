pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets

import qs
import qs.bar.widgets

Item {
  id: root

  width: audioOutputIndicator.width
  property string popupName: "audioOutputPopup"

  Rectangle {
    id: audioOutputBox
    width: audioOutputIndicator.width
    height: root.implicitHeight
    color: "transparent"
    ClippedProgressBar {
      id: audioOutputIndicator
      anchors.centerIn: parent
      width: audioInputRow.width
      height: audioInputRow.height
      value: Pipewire.defaultAudioSink?.audio.volume || 0.0
      RowLayout {
        id: audioInputRow
        width: icon.implicitWidth + content.width + Variables.progressBarPadding
        height: content.height
        spacing: 0
        Rectangle {
          id: iconRect
          Layout.fillWidth: true
          Layout.preferredWidth: icon.width
          Layout.preferredHeight: parent.height
          color: "transparent"
          Text {
            id: icon
            anchors.right: parent.right
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.Right
            text: {
              const default_sink = Pipewire.defaultAudioSink;
              let icon = "\uE04D"; // volume low
              if (!!default_sink) {
                if (default_sink?.audio.muted) {
                  icon = "\uE04F"; // volume off
                } else {
                  if (default_sink?.audio.volume >= .5) {
                    icon = "\uE050"; // volume high
                  } else if (default_sink.audio.volume == 0) {
                    icon = "\uE04F"; // volume off
                  } else {
                    icon = "\uE04D"; // volume low
                  }
                }
              }
              return icon;
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
          Text {
            id: content
            color: Theme.progressBarColour
            font {
              family: Variables.fontFamilyText
              pointSize: Variables.fontSizeSmall
            }
            Layout.alignment: Qt.AlignLeft
            text: {
              const default_sink = Pipewire.defaultAudioSink;
              const volume = default_sink?.audio.volume;
              const is_muted = default_sink?.audio.muted;
              let volume_text = Math.round(volume * 100).toString();
              volume_text = " ".repeat(Math.max(0, 3 - volume_text.length)) + volume_text;
              return `${volume_text}`;
            }
          }
        }
      }
    }
  }

  MouseArea {
    width: audioOutputBox.width
    height: root.implicitHeight
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onWheel: function (event) {
      const default_sink = Pipewire.defaultAudioSink;
      if (!default_sink) {
        return;
      }
      if (event.angleDelta.y > 0) {
        default_sink.audio.muted = false;
        default_sink.audio.volume = Math.min(default_sink.audio.volume + 0.01, 1.0);
      } else if (event.angleDelta.y < 0) {
        default_sink.audio.muted = false;
        if (default_sink.audio.volume > 0.0) {
          default_sink.audio.volume = Math.max(default_sink.audio.volume - 0.01, 0.0);
        }
      }
    }
    onEntered: function () {
      let sources = Pipewire.linkGroups.values.filter(x => x.source.isStream).map(x => x.source);
      if (!audioPopup.audioPopupIsActive) {
        audioTooltip.activateTooltip();
      }
    }
    onExited: function () {
      audioTooltip.deactivateTooltip();
    }
    onClicked: function (event) {
      audioTooltip.deactivateTooltip();
      audioPopup.audioPopupIsActive = true;
      audioPopup.activatePopup();
      GlobalStates.currentPopupName = root.popupName;
    }
  }
  Tooltip {
    id: audioTooltip
    parentItem: audioOutputBox
    delay: 50
    Component {
      Rectangle {
        id: audioTooltipBox
        color: Theme.barBgColour
        opacity: 0
        radius: Variables.radius
        border.width: Variables.borderWidth
        border.color: Theme.borderColour
        width: audioTooltipText.width
        height: audioTooltipText.height
        Text {
          id: audioTooltipText
          anchors.centerIn: parent
          text: Pipewire?.defaultAudioSink.nickname || "No audio output detected"
          font.pointSize: Variables.fontSizeTooltip
          padding: Variables.paddingTooltip
          color: Theme.tooltipColour
        }
        Behavior on opacity {
          NumberAnimation {
            duration: 150
          }
        }
      }
    }
  }

  AudioOutputVolumeControl {
    id: audioPopup
    parentItem: audioOutputBox
  }

  Connections {
    target: Pipewire
    function onDefaultAudioSinkChanged() {
      Pipewire.defaultAudioSink.audio.mute = false;
    }
  }

  Connections {
    target: GlobalStates
    function onCurrentPopupNameChanged() {
      if (GlobalStates.currentPopupName !== root.popupName) {
        audioPopup.deactivatePopupImmediate();
      }
    }
  }
}
