import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: button

    anchors.top: parent.top
    anchors.topMargin: 15

    anchors.right: parent.right

    width: 32
    height: 32

    color: mouseArea.containsPress ? "black" : (mouseArea.containsMouse ? "gray" : "transparent")

    radius: 32

    border.width: 2
    border.color: "gray"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true

        cursorShape: Qt.PointingHandCursor

        onReleased: if(containsMouse) stack.pop()
    }

    Text {
        text: "X"

        color: "white"

        anchors.centerIn: parent
    }

    Text {
        anchors.top: button.bottom
        anchors.topMargin: 3

        anchors.horizontalCenter: button.horizontalCenter

        horizontalAlignment: Text.AlignHCenter

        font.bold: true

        text: "ESC"

        color: "grey"
    }

    Shortcut {
        sequence: "ESC"
        onActivated: stack.pop()
    }
}
