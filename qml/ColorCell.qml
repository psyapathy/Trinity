import QtQuick 2.0

Rectangle {
    width: 32
    height: 32

    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        onReleased: settings.accentColor = parent.color
    }
}
