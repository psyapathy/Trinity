import QtQuick 2.2
import QtGraphicalEffects 1.0

Rectangle {
    id: button

    property string icon
    property string iconColor: "white"

    signal released

    color: "transparent"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true

        cursorShape: Qt.PointingHandCursor

        onReleased: if(containsMouse) button.released()
    }

    Image {
        id: directoryButtonImage

        anchors.fill: parent

        sourceSize.width: width
        sourceSize.height: height

        source: button.icon
    }

    ColorOverlay {
        anchors.fill: directoryButtonImage
        source: directoryButtonImage

        color: parent.iconColor
    }
}
