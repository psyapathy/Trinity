import QtQuick 2.6
import QtQuick.Controls 2.3

Popup {
    id: dialog

    width: imagePreview.paintedWidth
    height: imagePreview.height + downloadLink.contentHeight

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    modal: true

    background: null

    property string url

    Image {
        id: imagePreview

        width: 500
        fillMode: Image.PreserveAspectFit

        anchors.centerIn: parent

        source: url
    }

    Text {
        id: downloadLink

        x: imagePreview.x + (imagePreview.width - imagePreview.paintedWidth / 2) - contentWidth - 13

        anchors.top: imagePreview.bottom
        anchors.topMargin: 5

        text: "Download"

        color: "#048dc2"

        z: 5

        MouseArea {
            anchors.fill: downloadLink

            cursorShape: Qt.PointingHandCursor

            onReleased: Qt.openUrlExternally(url)
        }
    }
}
