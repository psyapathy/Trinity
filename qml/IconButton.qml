import QtQuick 2.2
import QtGraphicalEffects 1.0

Item {
    id: iconButton

    property string icon

    signal released

    Rectangle {
        id: directoryButton

        width: 28
        height: 28

        //onClicked: stack.push("qrc:/Directory.qml")

        //hoverEnabled: true

        color: mouseArea.containsPress ? "#0037FD" : (mouseArea.containsMouse ? "#3486FD" : "#1e74fd")

        radius: 35

        property bool down

        MouseArea {
            id: mouseArea

            anchors.fill: parent

            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onReleased: if(containsMouse) iconButton.released()
        }

        Image {
            id: directoryButtonImage

            anchors.centerIn: parent

            width: 23
            height: 23

            sourceSize.width: width
            sourceSize.height: height

            source: iconButton.icon
        }

        ColorOverlay {
            anchors.fill: directoryButtonImage
            source: directoryButtonImage

            color: "white"
        }
    }
}
