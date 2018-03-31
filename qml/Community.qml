import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: communityDescription

    color: Qt.rgba(0.1, 0.1, 0.1, 1.0)

    property var community

    Rectangle {
        width: 700
        height: parent.height

        anchors.horizontalCenter: parent.horizontalCenter

        color: "transparent"

        BackButton {
            id: backButton

            anchors.top: parent.top
            anchors.topMargin: 15

            anchors.right: parent.right
        }

        Image {
            id: communityAvatar

            anchors.top: backButton.bottom
            anchors.topMargin: 15

            width: 64
            height: 64

            sourceSize.width: 64
            sourceSize.height: 64

            source: community.avatar

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: communityAvatar.width
                    height: communityAvatar.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: communityAvatar.width
                        height: communityAvatar.height
                        radius: Math.min(width, height)
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: communityAvatar

            cursorShape: Qt.PointingHandCursor

            onReleased: showImage(community.avatar)
        }

        Text {
            id: communityNameLabel

            anchors.left: communityAvatar.right
            anchors.leftMargin: 10
            anchors.verticalCenter: communityAvatar.verticalCenter

            text: community.name

            color: "white"

            font.pointSize: 25
        }

        Text {
            id: communityShortDescriptionLabel

            anchors.top: communityAvatar.bottom
            anchors.topMargin: 15

            text: community.shortDescription

            color: "gray"
        }

        Text {
            id: communityLongDescriptionLabel

            width: parent.width

            anchors.top: communityShortDescriptionLabel.bottom
            anchors.topMargin: 15

            text: community.longDescription

            wrapMode: Text.WrapAnywhere

            color: "white"
        }
    }
}
