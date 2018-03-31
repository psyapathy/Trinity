import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.0

import trinity.matrix 1.0

Rectangle {
    id: roomDirectory

    color: Qt.rgba(0.1, 0.1, 0.1, 1.0)

    Component.onCompleted: matrix.loadDirectory()

    Rectangle {
        width: 700
        height: parent.height

        anchors.horizontalCenter: parent.horizontalCenter

        color: "transparent"

        BackButton {}

        Text {
            id: directoryLabel

            anchors.top: parent.top
            anchors.topMargin: 15

            text: "Directory"

            font.pointSize: 25
            font.bold: true

            color: "white"
        }

        ListView {
            width: parent.width
            height: parent.height

            anchors.top: directoryLabel.bottom
            anchors.topMargin: 10

            model: matrix.publicRooms

            clip: true

            ScrollBar.vertical: ScrollBar {}

            boundsBehavior: Flickable.StopAtBounds

            spacing: 5

            delegate: Rectangle {
                width: parent.width
                height: 40 + roomTopic.contentHeight

                color: mouseArea.containsPress ? "black" : (mouseArea.containsMouse ? "gray" : "transparent")

                radius: 5

                Image {
                    id: roomAvatar

                    width: 32
                    height: 32

                    anchors.top: parent.top
                    anchors.topMargin: 15
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    source: avatarURL ? avatarURL : "placeholder.png"

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: roomAvatar.width
                            height: roomAvatar.height
                            Rectangle {
                                anchors.centerIn: parent
                                width: roomAvatar.width
                                height: roomAvatar.height
                                radius: Math.min(width, height)
                            }
                        }
                    }
                }

                Text {
                    id: roomName

                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.left: roomAvatar.right
                    anchors.leftMargin: 15

                    text: alias

                    font.bold: true

                    color: "white"
                }

                Text {
                    id: roomTopic

                    width: parent.width

                    anchors.top: roomName.bottom
                    anchors.topMargin: 5
                    anchors.left: roomAvatar.right
                    anchors.leftMargin: 15

                    text: topic

                    wrapMode: Text.Wrap

                    color: "white"
                }

                MouseArea {
                    id: mouseArea

                    hoverEnabled: true

                    cursorShape: Qt.PointingHandCursor

                    anchors.fill: parent

                    onReleased: {
                        if(containsMouse) {
                            matrix.joinRoom(id)
                            stack.pop()
                        }
                    }
                }
            }
        }
    }
}
