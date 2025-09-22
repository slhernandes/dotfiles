pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string date

    Process {
        id: dateProc
        command: ["date", "+%a,\ %d.%m.%Y\ ·\ %H:%M:%S"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.date = this.text;
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
