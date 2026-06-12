pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Effects

import qs

/**
 * A progress bar with both ends rounded and text acts as clipping like OneUI 7's battery indicator.
 */
Rectangle {
  id: root
  color: "transparent"
  property real value: 0
  property color highlightColor: Theme.activeElement
  property color trackColor: Theme.inactiveElement
  property alias radius: contentItem.radius
  property bool vertical: false
  ProgressBar {
    id: progressBar
    value: root.value
    anchors.fill: parent
    property string text

    contentItem: Rectangle {
      id: contentItem
      anchors.fill: parent
      radius: 9999
      color: root.trackColor
      visible: false
      width: parent.width * progressBar.visualPosition
      height: root.height
      layer.enabled: true

      Rectangle {
        id: progressFill
        anchors {
          top: parent.top
          bottom: parent.bottom
          left: parent.left
          right: undefined
        }
        width: parent.width * progressBar.visualPosition
        height: parent.height

        states: State {
          name: "vertical"
          when: root.vertical
          AnchorChanges {
            target: progressFill
            anchors {
              top: undefined
              bottom: progressFill.parent.bottom
              left: progressFill.parent.left
              right: progressFill.parent.right
            }
          }
          PropertyChanges {
            target: progressFill
            progressFill.width: parent.width
            progressFill.height: parent.height * progressBar.visualPosition
          }
        }

        color: root.highlightColor
      }
    }

    Rectangle {
      id: maskRect
      color: "white"
      visible: false
      // anchors.fill: contentItem
      width: contentItem.width
      height: contentItem.height
      radius: 9999
      layer.enabled: true
      layer.smooth: true
    }

    MultiEffect {
      id: roundingMask
      visible: true
      anchors.fill: contentItem
      maskEnabled: true
      maskSpreadAtMin: 1.0
      maskThresholdMin: 0.5
      source: contentItem
      maskSource: maskRect
    }
  }
}
