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

  Rectangle {
    id: audioOutputBox
    width: audioOutputIndicator.width
    height: root.implicitHeight
    color: "transparent"
    ClippedProgressBar {
      id: audioOutputIndicator
      anchors.centerIn: parent
      width: audioInputRow.width
      value: Pipewire.defaultAudioSink?.audio.volume || 0.0
      RowLayout {
        id: audioInputRow
        width: icon.implicitWidth + content.width + 8
        spacing: 0
        IconImage {
          id: icon
          implicitHeight: content.height
          implicitWidth: content.height * 0.75
          Layout.alignment: Qt.AlignRight
          source: {
            const default_sink = Pipewire.defaultAudioSink;
            let icon_name = "volume_low.svg";
            if (!!default_sink) {
              if (default_sink?.audio.muted) {
                icon_name = "volume_mute.svg";
              } else {
                if (default_sink?.audio.volume >= .5) {
                  icon_name = "volume_high.svg";
                } else if (default_sink.audio.volume == 0) {
                  icon_name = "volume_mute.svg";
                } else {
                  icon_name = "volume_low.svg";
                }
              }
            }
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

  MouseArea {
    width: audioOutputBox.width
    height: root.implicitHeight
    hoverEnabled: true
    onWheel: function (event) {
      const default_sink = Pipewire.defaultAudioSink;
      if (!default_sink) {
        return;
      }
      if (event.angleDelta.y > 0) {
        default_sink.audio.muted = false;
        default_sink.audio.volume += 0.01;
      } else if (event.angleDelta.y < 0) {
        default_sink.audio.muted = false;
        default_sink.audio.volume -= 0.01;
      }
    }
    onEntered: function () {
      audioTooltip.activateTooltip();
    }
    onExited: function () {
      audioTooltip.deactivateTooltip();
    }
  }
  Tooltip {
    id: audioTooltip
    parentItem: audioOutputBox
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
  Connections {
    target: Pipewire
    function onDefaultAudioSinkChanged() {
      console.log("Audio Changed!!:", Pipewire.defaultAudioSink.description);
      Pipewire.defaultAudioSink.audio.mute = false;
    }
  }
}
