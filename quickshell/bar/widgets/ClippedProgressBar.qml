import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import qs

/**
 * A progress bar with both ends rounded and text acts as clipping like OneUI 7's battery indicator.
 */
ProgressBar {
  id: root
  property bool vertical: false
  property real valueBarWidth: content.width
  property real valueBarHeight: content.height
  property color highlightColor: Theme.get.activeElement
  property color trackColor: Theme.get.inactiveElement
  property alias radius: contentItem.radius
  required property string text
  default property Item textMask: Item {
    width: Math.round(content.width)
    height: Math.round(content.height)
    Text {
      id: content
      anchors.centerIn: parent
      font {
        family: Variables.fontFamilyText
        pointSize: Variables.fontSizeSmall
      }
      text: ` ${root.text} `
    }
  }

  background: Item {
    implicitHeight: root.valueBarHeight
    implicitWidth: root.valueBarWidth
  }

  contentItem: Rectangle {
    id: contentItem
    anchors.fill: parent
    radius: 9999
    color: root.trackColor
    visible: false
    width: parent.width * root.visualPosition
    height: root.valueBarHeight

    Rectangle {
      id: progressFill
      anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        right: undefined
      }
      width: parent.width * root.visualPosition
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
          progressFill.height: parent.height * root.visualPosition
        }
      }

      radius: 2
      color: root.highlightColor
    }
  }

  OpacityMask {
    id: roundingMask
    visible: false
    anchors.fill: parent
    source: contentItem
    maskSource: Rectangle {
      width: contentItem.width
      height: contentItem.height
      radius: contentItem.radius
    }
  }

  OpacityMask {
    anchors.fill: parent
    source: roundingMask
    invert: true
    maskSource: root.textMask
  }

  // Rectangle {
  //   width: root.valueBarWidth
  //   height: root.valueBarHeight
  //   anchors.centerIn: parent
  // }
}
