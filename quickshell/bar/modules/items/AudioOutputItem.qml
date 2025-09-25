import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

import qs.bar.widgets

Item {
  id: root
  width: audioOutputIndicator.width

  PwObjectTracker {
    objects: [...Pipewire.nodes.values].filter(v => {
      return v.isSink;
    })
  }

  Rectangle {
    id: audioOuputBox
    width: audioOutputIndicator.width
    height: root.height
    color: "transparent"
    ClippedProgressBar {
      id: audioOutputIndicator
      anchors.centerIn: parent
      text: {
        const default_sink = Pipewire.defaultAudioSink;
        const volume = default_sink.audio.volume;
        const is_muted = default_sink.audio.muted;
        let icon = is_muted ? "󰝟" : "󰖀";
        let volume_text = Math.round(volume * 100).toString();
        console.log(volume_text);
        volume_text = " ".repeat(Math.max(0, 3 - volume_text.length)) + volume_text;
        return `${icon}${volume_text}`;
      }
      value: Pipewire.defaultAudioSink.audio.volume
    }
  }

  MouseArea {
    width: audioOuputBox.width
    height: root.height
    onWheel: function (event) {
      const default_sink = Pipewire.defaultAudioSink;
      if (event.angleDelta.y > 0) {
        default_sink.audio.muted = false;
        default_sink.audio.volume += 0.01;
      } else if (event.angleDelta.y < 0) {
        default_sink.audio.muted = false;
        default_sink.audio.volume -= 0.01;
      }
    }
  }
}
