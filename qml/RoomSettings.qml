import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: roomSettings

    color: Qt.rgba(0.1, 0.1, 0.1, 1.0)

    property var room

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

        Text {
            id: roomNameLabel

            anchors.top: parent.top
            anchors.topMargin: 15

            text: room.name

            font.pointSize: 25
            font.bold: true

            color: "white"
        }

        TabBar {
            id: bar

            anchors.top: roomNameLabel.bottom

            TabButton {
                text: "Overview"
            }
        }

        SwipeView {
            id: settingsStack

            anchors.top: bar.bottom

            width: parent.width
            height: parent.height

            currentIndex: bar.currentIndex

            clip: true

            Item {
                id: overviewTab

                Label {
                    id: nameLabel

                    text: "Name"
                }

                TextField {
                    id: nameField

                    text: room.name

                    anchors.top: nameLabel.bottom
                }

                Label {
                    id: topicLabel

                    text: "Topic"

                    anchors.top: nameField.bottom
                }

                TextField {
                    id: topicField

                    text: room.topic

                    anchors.top: topicLabel.bottom
                }
            }
        }
    }
}
