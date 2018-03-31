import QtQuick 2.9
import QtQuick.Templates 2.2 as T

T.MenuItem {
    id: control

    width: parent.width
    height: 25

    contentItem: Text {
        anchors.left: parent.left
        anchors.leftMargin: 5

        text: control.text

        color: "white"
    }

    background: Rectangle {
        anchors.fill: parent

        color: control.down ? "#15151a" : "transparent"
    }
}
