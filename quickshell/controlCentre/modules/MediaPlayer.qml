import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris

import qs
import qs.controlCentre.widgets

CCModuleBlock {
  id: root
  required property real cellSize
  required property real moduleGap
  property int idx: 0
  property real boxSize: 150
  property var players: Mpris.players.values
  signal prevPlayer
  signal nextPlayer
  signal prevTrack
  signal nextTrack
  signal togglePlay

  ColumnLayout {
    anchors.centerIn: parent
    Layout.fillHeight: true
    RowLayout {
      implicitWidth: root.cellSize * 2 + root.moduleGap
      Layout.alignment: Qt.AlignTop
      MouseArea {
        id: leftChevronMouseArea
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        implicitWidth: leftChevron.implicitSize
        implicitHeight: leftChevron.implicitSize
        Layout.alignment: Qt.AlignLeft
        Rectangle {
          implicitWidth: leftChevron.implicitSize
          implicitHeight: leftChevron.implicitSize
          radius: 999
          color: leftChevronMouseArea.containsMouse ? Theme.activeElement : "transparent"
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }
        IconImage {
          id: leftChevron
          Layout.alignment: Qt.AlignLeft
          implicitSize: 30
          source: `file://${Variables.configDir}/icons/chevron_backward.png`
        }
        function prevPlayer() {
          const len = root.players.length;
          let tmp = root.idx - 1;
          if (tmp < 0) {
            root.idx = tmp + len;
          } else {
            root.idx = tmp;
          }
        }
        onClicked: event => prevPlayer()
      }
      Rectangle {
        color: "transparent"
        Layout.fillWidth: true
        implicitHeight: 30
        Text {
          id: playerName
          anchors.centerIn: parent
          text: {
            let t = root.players[root.idx].identity;
            if (t.includes("firefox")) {
              return "firefox";
            } else if (t.includes("MPD")) {
              return "MPD";
            }
            if (t.length > 12) {
              t = t.slice(0, 12) + "…";
            }
            return t;
          }
          font.family: Variables.fontFamilyTextCC
          font.pointSize: 12
          color: Theme.ccTextColour
        }
      }
      MouseArea {
        id: rightChevronMouseArea
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        implicitWidth: rightChevron.implicitSize
        implicitHeight: rightChevron.implicitSize
        Layout.alignment: Qt.AlignLeft
        Rectangle {
          implicitWidth: rightChevron.implicitSize
          implicitHeight: rightChevron.implicitSize
          radius: 999
          color: rightChevronMouseArea.containsMouse ? Theme.activeElement : "transparent"
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }
        IconImage {
          id: rightChevron
          Layout.alignment: Qt.AlignRight
          implicitSize: 30
          source: `file://${Variables.configDir}/icons/chevron_forward.png`
        }
        function nextPlayer() {
          const len = root.players.length;
          let tmp = root.idx + 1;
          if (tmp >= len) {
            root.idx = tmp - len;
          } else {
            root.idx = tmp;
          }
        }
        onClicked: event => nextPlayer()
      }
    }
    Rectangle {
      id: trackArtArea
      implicitWidth: root.boxSize
      implicitHeight: root.boxSize
      color: "transparent"
      IconImage {
        implicitSize: root.boxSize
        Layout.fillHeight: true
        source: {
          const trackArtUrl = root.players[root.idx].trackArtUrl;
          return trackArtUrl || `file://${Variables.configDir}/icons/hakase_no_img.png`;
        }
      }
    }
    Rectangle {
      implicitHeight: 24
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignBottom
      color: "transparent"
      Text {
        id: title
        anchors.centerIn: parent
        text: {
          let t = root.players[root.idx].trackTitle || "Unknown Title";
          const maxLen = 17;
          if (t.length > maxLen) {
            t = t.slice(0, Math.floor(maxLen / 2)) + "…" + t.slice(t.length - Math.floor(maxLen / 2), t.length);
          }
          return t;
        }
        font.family: Variables.fontFamilyTextCC
        font.pointSize: 12
        color: Theme.ccTextColour
      }
    }
    Rectangle {
      implicitHeight: 20
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignBottom
      color: "transparent"
      Text {
        id: album
        anchors.centerIn: parent
        text: {
          let t = root.players[root.idx].trackAlbum || "Unknown Album";
          const maxLen = 21;
          if (t.length > maxLen) {
            t = t.slice(0, Math.floor(maxLen / 2)) + "…" + t.slice(t.length - Math.floor(maxLen / 2), t.length);
          }
          return t;
        }
        font.family: Variables.fontFamilyTextCC
        font.pointSize: 10
        color: Theme.ccTextColour
      }
    }
    Rectangle {
      implicitHeight: 20
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignBottom
      color: "transparent"
      Text {
        id: artist
        anchors.centerIn: parent
        text: {
          let t = root.players[root.idx].trackArtist || "Unknown Artist";
          const maxLen = 21;
          if (t.length > maxLen) {
            t = t.slice(0, Math.floor(maxLen / 2)) + "…" + t.slice(t.length - Math.floor(maxLen / 2), t.length);
          }
          return t;
        }
        font.family: Variables.fontFamilyTextCC
        font.pointSize: 10
        color: Theme.ccTextColour
      }
    }
    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
      MouseArea {
        id: skipPrevMouseArea
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        implicitWidth: skipPrev.implicitSize
        implicitHeight: skipPrev.implicitSize
        Layout.alignment: Qt.AlignLeft
        Rectangle {
          implicitWidth: skipPrev.implicitSize
          implicitHeight: skipPrev.implicitSize
          radius: 999
          color: skipPrevMouseArea.containsMouse ? Theme.activeElement : "transparent"
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }
        IconImage {
          id: skipPrev
          Layout.alignment: Qt.AlignLeft
          implicitSize: 30
          source: `file://${Variables.configDir}/icons/skip_previous.png`
        }
        function prevTrack() {
          if (root.players[root.idx].canGoPrevious) {
            root.players[root.idx].previous();
          }
        }
        onClicked: event => prevTrack()
      }
      MouseArea {
        id: playPauseMouseArea
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        implicitWidth: playPause.implicitSize
        implicitHeight: playPause.implicitSize
        Layout.alignment: Qt.AlignLeft
        Rectangle {
          implicitWidth: playPause.implicitSize
          implicitHeight: playPause.implicitSize
          radius: 999
          color: playPauseMouseArea.containsMouse ? Theme.activeElement : "transparent"
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }
        IconImage {
          id: playPause
          Layout.alignment: Qt.AlignLeft
          implicitSize: 30
          source: {
            if (root.players[root.idx].isPlaying) {
              return `file://${Variables.configDir}/icons/pause.png`;
            }
            return `file://${Variables.configDir}/icons/play.png`;
          }
        }
        function togglePlay() {
          if (root.players[root.idx].isPlaying && root.players[root.idx].canPause) {
            root.players[root.idx].pause();
          } else if (!root.players[root.idx].isPlaying && root.players[root.idx].canPlay) {
            root.players[root.idx].play();
          }
        }
        onClicked: event => togglePlay()
      }
      MouseArea {
        id: skipNextMouseArea
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        implicitWidth: skipNext.implicitSize
        implicitHeight: skipNext.implicitSize
        Layout.alignment: Qt.AlignLeft
        Rectangle {
          implicitWidth: skipNext.implicitSize
          implicitHeight: skipNext.implicitSize
          radius: 999
          color: skipNextMouseArea.containsMouse ? Theme.activeElement : "transparent"
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }
        IconImage {
          id: skipNext
          Layout.alignment: Qt.AlignLeft
          implicitSize: 30
          source: `file://${Variables.configDir}/icons/skip_next.png`
        }
        function nextTrack() {
          if (root.players[root.idx].canGoNext) {
            root.players[root.idx].next();
          }
        }
        onClicked: event => nextTrack()
      }
    }
  }
  onPrevPlayer: () => leftChevronMouseArea.prevPlayer()
  onNextPlayer: () => rightChevronMouseArea.nextPlayer()
  onPrevTrack: () => skipPrevMouseArea.prevTrack()
  onNextTrack: () => skipNextMouseArea.nextTrack()
  onTogglePlay: () => playPauseMouseArea.togglePlay()
}
