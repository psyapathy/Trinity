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

        property color accentColor: settings.accentColor

        color: mouseArea.containsPress ? Qt.darker(accentColor, 1.5) : (mouseArea.containsMouse ? Qt.lighter(accentColor, 1.1) : accentColor)

        radius: 35

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
