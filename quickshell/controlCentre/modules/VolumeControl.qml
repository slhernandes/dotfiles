import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs
import qs.bar.widgets
import qs.controlCentre.widgets

CCModuleBlock {
  id: root
  required property real cellSize
  required property real moduleGap
  property real panelWidth: cellSize * 2 + moduleGap
  signal volumeSinkUp
  signal volumeSinkDown
  signal volumeSourceUp
  signal volumeSourceDown
  signal toggleMuteSink
  signal toggleMuteSource
  ColumnLayout {
    anchors.centerIn: parent
    RowLayout {
      Layout.alignment: Qt.AlignHCenter
      MouseArea {
        id: audioOutputMouseArea
        hoverEnabled: true
        implicitWidth: audioOutputIcon.width
        implicitHeight: audioOutputIcon.height
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        Rectangle {
          anchors.fill: parent
          anchors.centerIn: parent
          color: audioOutputMouseArea.containsMouse ? Theme.activeElement : "transparent"
          radius: 999
          Text {
            id: audioOutputIcon
            height: 0.15 * root.panelWidth
            width: 0.15 * root.panelWidth
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
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
            font.pixelSize: Variables.fontSizeIconL
            font.family: Variables.fontFamilyTextIcons
            color: Theme.osdIconColor
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }
        onClicked: function (event) {
          const default_sink = Pipewire.defaultAudioSink;
          if (!!default_sink) {
            default_sink.audio.muted = !default_sink.audio.muted;
          }
        }
      }
      MouseArea {
        implicitWidth: audioOutput.implicitWidth
        implicitHeight: audioOutput.implicitHeight
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        ClippedProgressBar {
          id: audioOutput
          implicitWidth: Math.round(0.7 * root.panelWidth)
          highlightColor: Theme.activeElement
          value: Pipewire.defaultAudioSink?.audio.volume || 0.0
          Item {}
        }
        function setVolume(event) {
          let xPos = event.x;
          const maxPos = audioOutput.implicitWidth;
          if (xPos < 0) {
            xPos = 0;
          } else if (xPos > maxPos) {
            xPos = maxPos;
          }
          let volume = Math.round(xPos / maxPos * 100) / 100;
          let audio_sink = Pipewire.defaultAudioSink;
          if (!!audio_sink) {
            audio_sink.audio.volume = volume;
          }
        }
        onPressed: event => setVolume(event)
        onPositionChanged: event => setVolume(event)
      }
    }
    RowLayout {
      Layout.alignment: Qt.AlignHCenter
      MouseArea {
        id: audioInputMouseArea
        hoverEnabled: true
        implicitWidth: audioInputIcon.width
        implicitHeight: audioInputIcon.height
        cursorShape: Qt.PointingHandCursor
        Rectangle {
          anchors.fill: parent
          anchors.centerIn: parent
          color: audioInputMouseArea.containsMouse ? Theme.activeElement : "transparent"
          radius: 999
          Text {
            id: audioInputIcon
            height: 0.15 * root.panelWidth
            width: 0.15 * root.panelWidth
            verticalAlignment: Text.AlignVCenter
            anchors.centerIn: parent
            text: {
              const default_source = Pipewire.defaultAudioSource;
              let icon = "\uE029";
              if (default_source?.audio.muted) {
                icon = "\uE02B";
              }
              return icon;
            }
            font.pixelSize: Variables.fontSizeIconL
            font.family: Variables.fontFamilyTextIcons
            color: Theme.osdIconColor
          }
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }
        onClicked: function (event) {
          const default_source = Pipewire.defaultAudioSource;
          if (!!default_source) {
            default_source.audio.muted = !default_source.audio.muted;
          }
        }
      }
      MouseArea {
        implicitWidth: audioInput.implicitWidth
        implicitHeight: audioInput.implicitHeight
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        ClippedProgressBar {
          id: audioInput
          implicitWidth: Math.round(0.7 * root.panelWidth)
          highlightColor: Theme.activeElement
          value: Pipewire.defaultAudioSource?.audio.volume || 0.0
          Item {}
        }
        function setVolumeInput(event) {
          let xPos = event.x;
          const maxPos = audioInput.implicitWidth;
          if (xPos < 0) {
            xPos = 0;
          } else if (xPos > maxPos) {
            xPos = maxPos;
          }
          let volume = Math.round(xPos / maxPos * 100) / 100;
          let audio_source = Pipewire.defaultAudioSource;
          if (!!audio_source) {
            audio_source.audio.volume = volume;
          }
        }
        onPressed: event => setVolumeInput(event)
        onPositionChanged: event => setVolumeInput(event)
      }
    }
  }

  onVolumeSinkUp: function () {
    const sink = Pipewire.defaultAudioSink;
    if (!!sink) {
      sink.audio.volume += 0.01;
      sink.audio.volume = Math.min(sink.audio.volume, 1.0);
    }
  }
  onVolumeSinkDown: function () {
    const sink = Pipewire.defaultAudioSink;
    if (!!sink) {
      sink.audio.volume -= 0.01;
      sink.audio.volume = Math.max(sink.audio.volume, 0);
    }
  }
  onVolumeSourceUp: function () {
    const source = Pipewire.defaultAudioSource;
    if (!!source) {
      source.audio.volume += 0.01;
      source.audio.volume = Math.min(source.audio.volume, 1.0);
    }
  }
  onVolumeSourceDown: function () {
    const source = Pipewire.defaultAudioSource;
    if (!!source) {
      source.audio.volume -= 0.01;
      source.audio.volume = Math.max(source.audio.volume, 0);
    }
  }
  onToggleMuteSink: function () {
    const sink = Pipewire.defaultAudioSink;
    if (!!sink) {
      sink.audio.muted = !sink.audio.muted;
    }
  }
  onToggleMuteSource: function () {
    const source = Pipewire.defaultAudioSource;
    if (!!source) {
      source.audio.muted = !source.audio.muted;
    }
  }
}
