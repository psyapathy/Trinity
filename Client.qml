import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0

import trinity.matrix 1.0

Rectangle {
    id: client
    color: Qt.rgba(0.05, 0.05, 0.05, 1.0)

    property var shouldScroll: false

    ListView {
       id: channels
       width: 150
       height: parent.height
       anchors.right: rightArea.left
       anchors.left: client.left

       model: matrix.roomListModel

       clip: true

       section.property: "section"
       section.criteria: ViewSection.FullString
       section.delegate: Rectangle {
           width: parent.width
           height: 25

           color: "transparent"

           Text {
               text: section

               color: "red"
           }
       }

       delegate: Rectangle {
            width: 150
            height: 25

            property bool selected: channels.currentIndex === matrix.roomListModel.getOriginalIndex(index)

            color: selected ? "white" : "transparent"

            radius: 5

            Image {
                id: roomAvatar

                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5

                width: 18
                height: 18

                sourceSize.width: 18
                sourceSize.height: 18

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
                text: alias

                anchors.verticalCenter: parent.verticalCenter

                anchors.left: roomAvatar.right
                anchors.leftMargin: 5

                color: selected ? "black" : (highlightCount > 0 ? "red" : (notificationCount > 0 ? "blue" : "white"))
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onReleased: {
                    if(mouse.button == Qt.LeftButton) {
                        if(!selected) {
                            var originalIndex = matrix.roomListModel.getOriginalIndex(index)
                            matrix.changeCurrentRoom(originalIndex)
                            channels.currentIndex = originalIndex
                        }
                    } else
                        contextMenu.popup()
                }
            }

            Menu {
                id: contextMenu

                MenuItem {
                    text: "Settings"

                    onClicked: stack.push("qrc:/RoomSettings.qml", {"room": matrix.getRoom(index)})
                }

                MenuSeparator {}

                MenuItem {
                    text: "Leave Room"

                    onReleased: {
                        showDialog("Leave Confirmation", "Are you sure you want to leave " + alias + "?", [
                                       {
                                           text: "Yes",
                                           onClicked: function(dialog) {
                                                matrix.leaveRoom(id)
                                                dialog.close()
                                           }
                                       },
                                       {
                                           text: "No",
                                           onClicked: function(dialog) {
                                               dialog.close()
                                           }
                                       }
                                   ])
                    }
                }
            }
       }
    }

    Button {
        id: communitiesButton

        width: channels.width

        anchors.bottom: channels.bottom

        text: "Communities"

        onClicked: stack.push("qrc:/Communities.qml")
    }

    Button {
        id: directoryButton

        width: channels.width

        anchors.bottom: communitiesButton.top

        text: "Directory"

        onClicked: stack.push("qrc:/Directory.qml")
    }

    Rectangle {
        id: rightArea
        height: parent.height
        width: parent.width - channels.width
        anchors.left: channels.right

        color: "green"

        Rectangle {
            id: roomHeader
            height: 45
            width: parent.width

            anchors.bottom: messagesArea.top

            color: Qt.rgba(0.3, 0.3, 0.3, 1.0)

            Image {
                id: channelAvatar

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15

                width: 33
                height: 33

                sourceSize.width: 33
                sourceSize.height: 33

                fillMode: Image.PreserveAspectFit

                source: matrix.currentRoom.avatar ? matrix.currentRoom.avatar : "placeholder.png"

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: 33
                        height: 33
                        Rectangle {
                            anchors.centerIn: parent
                            width: 33
                            height: 33
                            radius: Math.min(width, height)
                        }
                    }
                }
            }

            Text {
                id: channelTitle

                font.pointSize: 15

                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 15
                anchors.left: channelAvatar.right

                text: matrix.currentRoom.name

                color: "white"
            }

            Text {
                id: channelTopic

                width: showMemberListButton.x - x

                font.pointSize: 12

                anchors.verticalCenter: parent.verticalCenter

                anchors.left: channelTitle.right
                anchors.leftMargin: 5

                text: {
                    if(matrix.currentRoom.direct)
                        return "";

                    if(matrix.currentRoom.topic.length == 0)
                        return "This room has no topic set."
                    else
                        return matrix.currentRoom.topic
                }

                color: "gray"

                elide: Text.ElideRight

                MouseArea {
                    anchors.fill: parent

                    onReleased: showDialog(matrix.currentRoom.name, matrix.currentRoom.topic)
                }
            }

            ToolButton {
                id: showMemberListButton

                anchors.verticalCenter: parent.verticalCenter

                anchors.right: settingsButton.left
                anchors.rightMargin: 10

                icon.name: "face-plain"

                onClicked: {
                    if(memberList.width == 0)
                        memberList.width = 200
                    else
                        memberList.width = 0
                }

                ToolTip.visible: hovered
                ToolTip.text: "Member List"
            }

            ToolButton {
                id: settingsButton

                anchors.verticalCenter: parent.verticalCenter

                anchors.right: parent.right
                anchors.rightMargin: 10

                icon.name: "preferences-system"

                onClicked: stack.push("qrc:/Settings.qml")

                ToolTip.visible: hovered
                ToolTip.text: "Settings"
            }
        }

        Rectangle {
            id: messagesArea

            width: parent.width - memberList.width
            height: parent.height - roomHeader.height

            anchors.top: roomHeader.bottom

            Rectangle {
                height: parent.height - messageInputParent.height
                width: parent.width

                clip: true

                color: Qt.rgba(0.1, 0.1, 0.1, 1.0)

                ListView {
                    id: messages
                    model: matrix.eventModel

                    anchors.fill: parent

                    delegate: Rectangle {                        
                        width: parent.width
                        height: (condense ? 5 : 25) + message.contentHeight

                        color: "transparent"

                        Image {
                            id: avatar

                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 5

                            sourceSize.width: 33
                            sourceSize.height: 33

                            source: avatarURL ? avatarURL : "placeholder.png"

                            visible: !condense

                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Item {
                                    width: avatar.width
                                    height: avatar.height
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: avatar.width
                                        height: avatar.height
                                        radius: Math.min(width, height)
                                    }
                                }
                            }
                        }

                        Text {
                            id: senderText

                            text: condense ? "" : sender

                            color: "white"

                            anchors.left: avatar.right
                            anchors.leftMargin: 10
                        }

                        Text {
                            text: condense ? "" : timestamp

                            color: "gray"

                            anchors.left: senderText.right
                            anchors.leftMargin: 10
                        }

                        Text {
                            id: message

                            y: condense ? 0 : 20
                            text: msg

                            width: parent.width

                            wrapMode: Text.Wrap

                            color: sent ? "white" : "gray"

                            anchors.left: condense ? parent.left : avatar.right
                            anchors.leftMargin: condense ? 45 : 10
                        }

                        MouseArea {
                            anchors.fill: parent

                            acceptedButtons: Qt.RightButton

                            onClicked: contextMenu.popup()
                        }

                        Menu {
                            id: contextMenu

                            MenuItem {
                                text: "Remove"

                                onClicked: matrix.removeMessage(eventId)
                            }

                            MenuItem {
                                text: "Permalink"

                                onClicked: Qt.openUrlExternally("https://matrix.to/#/" + matrix.currentRoom.id + "/" + eventId)
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {}

                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.VerticalFlick
                    verticalLayoutDirection: ListView.BottomToTop

                    onMovingVerticallyChanged: {
                        if(verticalVelocity < 0)
                           matrix.readMessageHistory(matrix.currentRoom)
                    }

                    // we scrolled
                    onContentYChanged: {
                        var index = indexAt(0, contentY + height - 5)
                        matrix.readUpTo(matrix.currentRoom, index)
                    }

                    // a new message was added
                    onContentHeightChanged: {
                        var index = indexAt(0, contentY + height - 5)
                        matrix.readUpTo(matrix.currentRoom, index)
                    }
                }

                Rectangle {
                    id: overlay

                    anchors.fill: parent

                    visible: matrix.currentRoom.guestDenied

                    Text {
                        id: invitedByLabel

                        anchors.centerIn: parent

                        color: "white"

                        text: "You have been invited to this room by " + matrix.currentRoom.invitedBy
                    }

                    Button {
                        text: "Accept"

                        anchors.top: invitedByLabel.bottom

                        onReleased: {
                            matrix.joinRoom(matrix.currentRoom.id)
                        }
                    }
                }
            }

            Rectangle {
                id: messageInputParent

                anchors.top: messages.parent.bottom

                width: parent.width
                height: 55

                color: Qt.rgba(0.1, 0.1, 0.1, 1.0)

                ToolButton {
                    id: attachButton

                    icon.name: "mail-attachment"

                    width: 30
                    height: 30

                    anchors.top: parent.top
                    anchors.topMargin: 5

                    anchors.left: parent.left
                    anchors.leftMargin: 5
                }

                TextArea {
                    id: messageInput

                    width: parent.width - attachButton.width - 10
                    height: 30

                    anchors.top: parent.top
                    anchors.topMargin: 5

                    anchors.left: attachButton.right
                    anchors.leftMargin: 5

                    anchors.right: parent.right
                    anchors.rightMargin: 5

                    placeholderText: "Message " + matrix.currentRoom.name

                    Keys.onReturnPressed: {
                        if(event.modifiers & Qt.ShiftModifier) {
                            event.accepted = false
                        } else {
                            matrix.sendMessage(matrix.currentRoom, text)
                            clear()
                        }
                    }
                }

                ToolButton {
                    id: markdownButton

                    icon.name: "text-x-generic"

                    width: 20
                    height: 20

                    anchors.top: messageInput.top
                    anchors.topMargin: 5

                    anchors.right: emojiButton.left
                    anchors.rightMargin: 5
                }

                ToolButton {
                    id: emojiButton

                    icon.name: "face-smile"

                    width: 20
                    height: 20

                    anchors.top: messageInput.top
                    anchors.topMargin: 5

                    anchors.right: messageInput.right
                    anchors.rightMargin: 5
                }

                Text {
                    id: typingLabel

                    anchors.bottom: messageInputParent.bottom

                    color: "white"

                    text: matrix.typingText
                }
            }
        }

        Rectangle {
            id: memberList

            anchors.top: roomHeader.bottom
            anchors.left: messagesArea.right

            color: Qt.rgba(0.15, 0.15, 0.15, 1.0)

            width: matrix.currentRoom.direct ? 0 : 200
            height: parent.height - roomHeader.height

            ListView {
                model: matrix.memberModel

                anchors.fill: parent

                delegate: Rectangle {
                    width: parent.width
                    height: 50

                    color: "transparent"

                    property string memberId: id

                    Image {
                        id: memberAvatar

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        sourceSize.width: 33
                        sourceSize.height: 33

                        source: avatarURL ? avatarURL : "placeholder.png"

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Item {
                                width: memberAvatar.width
                                height: memberAvatar.height
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: memberAvatar.width
                                    height: memberAvatar.height
                                    radius: Math.min(width, height)
                                }
                            }
                        }
                    }

                    Text {
                        anchors.left: memberAvatar.right
                        anchors.leftMargin: 10

                        anchors.verticalCenter: parent.verticalCenter

                        color: "white"

                        text: displayName
                    }

                    MouseArea {
                        anchors.fill: parent

                        acceptedButtons: Qt.RightButton

                        onClicked: memberContextMenu.popup()
                    }

                    Menu {
                        id: memberContextMenu

                        MenuItem {
                            text: "Profile"

                            onReleased: {
                                var popup = Qt.createComponent("qrc:/Profile.qml")
                                var popupContainer = popup.createObject(client, {"parent": client, "member": matrix.resolveMemberId(id)})

                                popupContainer.open()
                            }
                        }

                        MenuItem {
                            text: "Mention"

                            onReleased: messageInput.append(displayName + ": ")
                        }

                        MenuItem {
                            text: "Start Direct Chat"

                            onReleased: matrix.startDirectChat(id)
                        }

                        MenuSeparator {}

                        Menu {
                            title: "Invite to room"

                            Repeater {
                                model: matrix.roomListModel

                                MenuItem {
                                    text: alias

                                    onReleased: {
                                        matrix.inviteToRoom(matrix.resolveRoomId(id), memberId)
                                    }
                                }
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {}

                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
            }
        }

        Button {
            id: inviteButton

            width: memberList.width

            anchors.bottom: memberList.bottom
            anchors.right: memberList.right

            text: "Invite to room"

            onClicked: {
                var popup = Qt.createComponent("qrc:/InviteDialog.qml")
                var popupContainer = popup.createObject(window, {"parent": window})

                popupContainer.open()
            }
        }
    }

    Timer {
        id: syncTimer
        interval: 1500
        running: true
        onTriggered: {
            if(messages.contentY == messages.contentHeight - messages.height)
                shouldScroll = true
            else
                shouldScroll = false

            matrix.sync()
        }
    }

    Timer {
        id: memberTimer
        interval: 60000
        running: true
        onTriggered: matrix.updateMembers(matrix.currentRoom)
    }

    Timer {
        id: typingTimer
        interval: 15000 //15 seconds
        running: true
        onTriggered: {
            if(messageInput.text.length !== 0)
                matrix.setTyping(matrix.currentRoom)
        }
    }

    Connections {
        target: matrix
        onSyncFinished: {
            syncTimer.start()

            if(shouldScroll)
                messages.positionViewAtEnd()
        }

        onInitialSyncFinished: {
            matrix.changeCurrentRoom(0)
        }

        onCurrentRoomChanged: {
            matrix.readMessageHistory(matrix.currentRoom)
            matrix.updateMembers(matrix.currentRoom)
        }

        onMessage: {
            if(content.includes(matrix.displayName))
                desktop.showMessage(matrix.resolveMemberId(sender).displayName, content)
        }
    }
}
