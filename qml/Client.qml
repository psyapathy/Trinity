import QtQuick 2.10
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2

import trinity.matrix 1.0

Rectangle {
    id: client

    property bool shouldScroll: false

    Rectangle {
        id: sidebar

        width: 195
        height: parent.height

        anchors.right: rightArea.left
        anchors.left: client.left

        z: 8

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, parent.height)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#22232c" }
                GradientStop { position: 1.0; color: "#23242d" }
            }
        }

        Rectangle {
            id: userHeader

            height: 55
            width: parent.width

            anchors.top: parent.top

            color: "#23242d"

            Text {
                x: 15
                y: 15

                text: matrix.displayName

                color: "white"
            }
        }

        DropShadow {
            anchors.fill: userHeader
            verticalOffset: 6
            radius: 8.0
            samples: 12
            cached: true
            source: userHeader
            opacity: 0.1

            z: 2
        }

        ListView {
           id: channels

           anchors.top: userHeader.bottom
           anchors.topMargin: 10

           height: parent.height - userHeader.height
           width: parent.width

           clip: true

           model: matrix.roomListModel

           spacing: 5

           ScrollBar.vertical: ScrollBar {}
           boundsBehavior: Flickable.StopAtBounds

           section.property: "section"
           section.criteria: ViewSection.FullString
           section.delegate: Rectangle {
               width: parent.width
               height: 25

               color: "transparent"

               anchors.left: parent.left
               anchors.leftMargin: 12

               Text {
                   anchors.verticalCenter: parent.verticalCenter

                   anchors.left: parent.left
                   anchors.leftMargin: 5

                   text: section

                   color: Qt.rgba(0.8, 0.8, 0.8, 1.0)

                   textFormat: Text.PlainText
               }
           }

           delegate: Rectangle {
                width: parent.width - 24
                height: 25

                property bool selected: channels.currentIndex === matrix.roomListModel.getOriginalIndex(index)

                color: selected ? "white" : (mouseArea.containsMouse ? Qt.rgba(0.75, 0.75, 0.75, 1.0) : "transparent")

                radius: 3

                anchors.left: parent.left
                anchors.leftMargin: 12

                Image {
                    id: roomAvatar

                    cache: true

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

                    color: selected || mouseArea.containsMouse ? "black" : (highlightCount > 0 ? "red" : (notificationCount > 0 ? "blue" : "white"))

                    textFormat: Text.PlainText
                }

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent

                    cursorShape: Qt.PointingHandCursor

                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    hoverEnabled: true

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
                        text: "Mark As Read"

                        onReleased: matrix.readUpTo(matrix.getRoom(matrix.roomListModel.getOriginalIndex(index)), 0)
                    }

                    MenuSeparator {}


                    Column {
                        spacing: 10

                        RadioButton {
                            text: "All messages"

                            ToolTip.text: "Recieve a notification for all messages in this room."
                            ToolTip.visible: hovered

                            onReleased: matrix.getRoom(matrix.roomListModel.getOriginalIndex(index)).notificationLevel = 2

                            checked: matrix.getRoom(matrix.roomListModel.getOriginalIndex(index)).notificationLevel === 2
                        }

                        RadioButton {
                            text: "Only Mentions"

                            ToolTip.text: "Recieve a notification for mentions in this room."
                            ToolTip.visible: hovered

                            onReleased: matrix.getRoom(matrix.roomListModel.getOriginalIndex(index)).notificationLevel = 1

                            checked: matrix.getRoom(matrix.roomListModel.getOriginalIndex(index)).notificationLevel === 1
                        }

                        RadioButton {
                            text: "Mute"

                            ToolTip.text: "Don't get notifications or unread indicators for this room."
                            ToolTip.visible: hovered

                            onReleased: matrix.getRoom(matrix.roomListModel.getOriginalIndex(index)).notificationLevel = 0

                            checked: matrix.getRoom(matrix.roomListModel.getOriginalIndex(index)).notificationLevel === 0
                        }
                    }

                    MenuSeparator {}

                    MenuItem {
                        text: "Room Settings"

                        onReleased: stack.push("qrc:/RoomSettings.qml", {"room": matrix.getRoom(matrix.roomListModel.getOriginalIndex(index))})
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

        ToolButton {
            id: directoryButton

            width: 28
            height: 28

            x: 35
            y: parent.height - 50

            onClicked: stack.push("qrc:/Directory.qml")

            background: Rectangle {
                color: "#1e74fd"

                radius: 35
            }

            Image {
                id: directoryButtonImage

                anchors.centerIn: parent

                width: 23
                height: 23

                sourceSize.width: width
                sourceSize.height: height

                source: "icons/directory.png"
            }

            ColorOverlay {
                anchors.fill: directoryButtonImage
                source: directoryButtonImage

                color: "white"
            }
        }

        ToolButton {
            id: communitiesButton

            width: 28
            height: 28

            x: 81
            y: parent.height - 50

            onClicked: stack.push("qrc:/Communities.qml")

            background: Rectangle {
                color: "#1e74fd"

                radius: 35
            }

            Image {
                id: communitiesButtonImage

                anchors.centerIn: parent

                width: 21
                height: 21

                sourceSize.width: width
                sourceSize.height: height

                source: "icons/communities.png"
            }

            ColorOverlay {
                anchors.fill: communitiesButtonImage
                source: communitiesButtonImage

                color: "white"
            }
        }

        ToolButton {
            id: settingsButton

            width: 28
            height: 28

            x: 125
            y: parent.height - 50

            onClicked: stack.push("qrc:/Settings.qml")

            background: Rectangle {
                color: "#1e74fd"

                radius: 35
            }

            Image {
                id: settingsButtonImage

                anchors.centerIn: parent

                width: 22
                height: 22

                sourceSize.width: width
                sourceSize.height: height

                source: "icons/settings.png"
            }

            ColorOverlay {
                anchors.fill: settingsButtonImage
                source: settingsButtonImage

                color: "white"
            }
        }
    }

    Rectangle {
        id: rightArea
        height: parent.height
        width: parent.width - sidebar.width
        anchors.left: sidebar.right

        Rectangle {
            id: roomHeader
            height: 55
            width: parent.width

            anchors.bottom: messagesArea.top

            color: "#2c2d35"

            z: 4

            Image {
                id: channelAvatar

                cache: true

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15

                width: 33
                height: 33

                sourceSize.width: 33
                sourceSize.height: 33

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

                anchors.top: parent.top
                anchors.topMargin: 4
                anchors.leftMargin: 15
                anchors.left: channelAvatar.right

                text: matrix.currentRoom.name

                color: "white"

                textFormat: Text.PlainText
            }

            Text {
                id: channelTopic

                width: showMemberListButton.x - x

                font.pointSize: 10

                anchors.top: channelTitle.bottom
                anchors.leftMargin: 15
                anchors.left: channelAvatar.right

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

                    cursorShape: Qt.PointingHandCursor

                    onReleased: showDialog(matrix.currentRoom.name, matrix.currentRoom.topic)
                }

                textFormat: Text.PlainText
            }

            ToolButton {
                id: showMemberListButton

                width: 25
                height: 25

                anchors.verticalCenter: parent.verticalCenter

                anchors.right: parent.right
                anchors.rightMargin: 15

                onClicked: {
                    if(memberList.width == 0)
                        memberList.width = 200
                    else
                        memberList.width = 0
                }

                ToolTip.visible: hovered
                ToolTip.text: "Member List"

                background: Rectangle { color: "transparent" }
                contentItem: Rectangle { color: "transparent" }

                visible: !matrix.currentRoom.direct

                Image {
                    id: memberListButtonImage

                    anchors.fill: parent

                    sourceSize.width: parent.width
                    sourceSize.height: parent.height

                    source: "icons/memberlist.png"
                }

                ColorOverlay {
                    anchors.fill: parent
                    source: memberListButtonImage

                    color: parent.hovered ? "white" : (memberList.width == 200 ? "white" : Qt.rgba(0.8, 0.8, 0.8, 1.0))
                }
            }
        }

        DropShadow {
            anchors.fill: roomHeader
            verticalOffset: 6
            radius: 8.0
            samples: 12
            cached: true
            source: roomHeader
            opacity: 0.1
            z: 4
        }

        Rectangle {
            id: messagesArea

            width: parent.width - memberList.width
            height: parent.height - roomHeader.height

            anchors.top: roomHeader.bottom

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(0, parent.height)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#1f2029" }
                    GradientStop { position: 1.0; color: "#1c1d24" }
                }
            }

            Rectangle {
                height: parent.height - messageInputParent.height
                width: parent.width

                clip: true

                color: "transparent"

                ListView {
                    id: messages
                    model: matrix.eventModel

                    anchors.fill: parent

                    cacheBuffer: 200

                    spacing: 3

                    delegate: Rectangle {                        
                        width: parent.width
                        height: (condense ? (nextCondense ? 2 : 12) : (nextCondense ? 23 : 35)) + messageArea.height

                        color: "transparent"

                        property string attachment: display.attachment
                        property var sender: matrix.resolveMemberId(display.sender)
                        property var eventId: display.eventId
                        property var msg: display.msg

                        Image {
                            id: avatar

                            width: 33
                            height: 33

                            cache: true

                            anchors.top: parent.top
                            anchors.topMargin: 13
                            anchors.left: parent.left
                            anchors.leftMargin: 13

                            sourceSize.width: 33
                            sourceSize.height: 33

                            source: sender ? (sender.avatarURL ? sender.avatarURL : "placeholder.png") : "placeholder.png"

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

                            text: condense ? "" : (sender ? sender.displayName : "Unknown")

                            color: "white"

                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.left: avatar.right
                            anchors.leftMargin: 17

                            textFormat: Text.PlainText
                        }

                        Text {
                            text: condense ? "" : timestamp

                            color: "gray"

                            font.pointSize: 9

                            anchors.top: parent.top
                            anchors.topMargin: 7
                            anchors.left: senderText.right
                            anchors.leftMargin: 5

                            textFormat: Text.PlainText
                        }

                        Rectangle {
                            id: messageArea

                            y: condense ? 5 : 25

                            height: {
                                if(display.msgType === "text")
                                    return message.contentHeight
                                else if(display.msgType === "image")
                                    return messageThumbnail.height
                                else
                                    return preview.height
                            }

                            width: parent.width - (condense ? 63 : 20)

                            anchors.left: condense ? parent.left : avatar.right
                            anchors.leftMargin: condense ? 63 : 17

                            color: "transparent"

                            TextEdit {
                                id: message

                                text: display.msg

                                width: parent.width

                                wrapMode: Text.Wrap
                                textFormat: Text.RichText

                                readOnly: true
                                selectByMouse: true

                                color: display.sent ? Qt.rgba(0.8, 0.8, 0.8, 1.0) : "gray"

                                visible: display.msgType === "text"
                            }

                            Image {
                                id: messageThumbnail

                                visible: display.msgType === "image"

                                source: display.thumbnail

                                fillMode: Image.PreserveAspectFit
                                width: Math.min(sourceSize.width, 400)
                            }

                            MouseArea {
                                enabled: display.msgType === "image"

                                cursorShape: Qt.PointingHandCursor

                                anchors.fill: messageThumbnail

                                onReleased: showImage(display.attachment)
                            }

                            Rectangle {
                                id: preview

                                width: 350
                                height: 45

                                visible: display.msgType === "file"

                                radius: 5

                                color: Qt.rgba(0.05, 0.05, 0.05, 1.0)

                                Text {
                                    id: previewFilename

                                    x: 15
                                    y: 7

                                    text: display.msg

                                    color: "#048dc2"
                                }

                                Text {
                                    id: previewFilesize

                                    x: 15
                                    y: 22

                                    font.pointSize: 9

                                    text: display.attachmentSize / 1000.0 + " KB"

                                    color: "gray"
                                }

                                ToolButton {
                                    id: previewFileDownload

                                    width: 25
                                    height: 25

                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10

                                    Image {
                                        id: downloadButtonImage

                                        anchors.fill: parent

                                        sourceSize.width: parent.width
                                        sourceSize.height: parent.height

                                        source: "icons/download.png"
                                    }

                                    ColorOverlay {
                                        anchors.fill: parent
                                        source: downloadButtonImage

                                        color: parent.hovered ? "white" : Qt.rgba(0.8, 0.8, 0.8, 1.0)
                                    }

                                    onClicked: {
                                        console.log(attachment)
                                        Qt.openUrlExternally(attachment)
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: messageMouseArea

                            anchors.fill: messageArea

                            acceptedButtons: Qt.RightButton

                            propagateComposedEvents: true

                            onClicked: messageContextMenu.popup()
                        }

                        Menu {
                            id: messageContextMenu

                            MenuItem {
                                text: "Remove"

                                onReleased: matrix.removeMessage(eventId)
                            }

                            MenuItem {
                                text: "Permalink"

                                onReleased: Qt.openUrlExternally("https://matrix.to/#/" + matrix.currentRoom.id + "/" + eventId)
                            }

                            MenuItem {
                                text: "Quote"

                                onReleased: messageInput.append("> " + msg + "\n\n")
                            }
                        }

                        MouseArea {
                            id: avatarMouseArea

                            anchors.fill: avatar

                            cursorShape: Qt.PointingHandCursor

                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            onReleased: {
                                if(mouse.button === Qt.RightButton) {
                                    avatarMenu.popup()

                                } else if(mouse.button === Qt.LeftButton) {
                                    var popup = Qt.createComponent("qrc:/Profile.qml")
                                    var popupContainer = popup.createObject(client, {"parent": client, "member": sender})

                                    popupContainer.open()
                                }
                            }
                        }

                        Menu {
                            id: avatarMenu

                            MenuItem {
                                text: "Profile"

                                onReleased: {
                                    var popup = Qt.createComponent("qrc:/Profile.qml")
                                    var popupContainer = popup.createObject(client, {"parent": client, "member": sender})

                                    popupContainer.open()
                                }
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

                        textFormat: Text.PlainText
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

                color: "transparent"

                ToolButton {
                    id: attachButton

                    icon.name: "mail-attachment"

                    width: 30
                    height: 30

                    anchors.top: parent.top
                    anchors.topMargin: 5

                    anchors.left: parent.left
                    anchors.leftMargin: 5

                    ToolTip.text: "Attach File"
                    ToolTip.visible: hovered

                    onReleased: openAttachmentFileDialog.open()
                }

                TextArea {
                    id: messageInput

                    width: parent.width - attachButton.width - 10
                    height: 30

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20

                    anchors.left: attachButton.right
                    anchors.leftMargin: 5

                    anchors.right: parent.right
                    anchors.rightMargin: 5

                    placeholderText: "Message " + matrix.currentRoom.name

                    Keys.onReturnPressed: {
                        if(event.modifiers & Qt.ShiftModifier) {
                            event.accepted = false
                        } else {
                            event.accepted = true
                            matrix.sendMessage(matrix.currentRoom, text)
                            clear()
                        }
                    }

                    onTextChanged: {
                        height = Math.max(30, contentHeight + 13)
                        parent.height = Math.max(55, contentHeight + 20)
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

                    ToolTip.text: "Markdown is " + (matrix.markdownEnabled ? "enabled" : "disabled")
                    ToolTip.visible: hovered

                    onReleased: matrix.markdownEnabled = !matrix.markdownEnabled
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

                    ToolTip.text: "Add emoji"
                    ToolTip.visible: hovered
                }

                Text {
                    id: typingLabel

                    anchors.bottom: messageInputParent.bottom

                    color: "white"

                    text: matrix.typingText

                    textFormat: Text.PlainText
                }
            }
        }

        Rectangle {
            id: memberList

            anchors.top: roomHeader.bottom
            anchors.left: messagesArea.right

            color: "#28292f"

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

                        cache: true

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

                        textFormat: Text.PlainText
                    }

                    MouseArea {
                        anchors.fill: parent

                        cursorShape: Qt.PointingHandCursor

                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onReleased: {
                            if(mouse.button === Qt.RightButton)
                                memberContextMenu.popup()
                            else if(mouse.button === Qt.LeftButton) {
                                var popup = Qt.createComponent("qrc:/Profile.qml")
                                var popupContainer = popup.createObject(client, {"parent": client, "member": matrix.resolveMemberId(id)})

                                popupContainer.open()
                            }
                        }
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
            shouldScroll = messages.contentY == messages.contentHeight - messages.height

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

        onInitialSyncFinished: matrix.changeCurrentRoom(0)

        onCurrentRoomChanged: {
            if(messages.contentY < messages.originY + 5)
                matrix.readMessageHistory(matrix.currentRoom)
        }

        onMessage: {
            var notificationLevel = room.notificationLevel
            var shouldDisplay = false

            if(notificationLevel === 2) {
                shouldDisplay = true
            } else if(notificationLevel === 1) {
                if(content.includes(matrix.displayName))
                    shouldDisplay = true
            }

            if(shouldDisplay && sender)
                desktop.showMessage(matrix.resolveMemberId(sender).displayName + " (" + room.name + ")", content)
        }

        onCallInvite: {
            var popup = Qt.createComponent("qrc:/CallDialog.qml")
            var popupContainer = popup.createObject(window, {"parent": window, callId: event["content"]["call_id"], originatingRoom: room, from: matrix.resolveMemberId(from).displayName})

            popupContainer.open()
            popupContainer.offer(event["content"]["offer"])
        }
    }

    FileDialog {
        id: openAttachmentFileDialog
        folder: shortcuts.home

        selectExisting: true
        selectFolder: false
        selectMultiple: false

        onAccepted: {
            matrix.uploadAttachment(matrix.currentRoom, fileUrl)
            close()
        }

        onRejected: close()
    }
}
