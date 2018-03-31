import QtQuick 2.9
import QtQuick.Templates 2.3 as T

T.Menu {
    id: control

    width: 150
    implicitHeight: contentItem.implicitHeight

    delegate: MenuItem { }

    contentItem: ListView {
        implicitHeight: contentHeight

        model: control.contentModel

        interactive: false

        currentIndex: control.currentIndex
    }

    background: Rectangle {
        anchors.fill: parent
        color: "#191a20"
        radius: 5
    }
}
