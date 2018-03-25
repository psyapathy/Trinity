import QtQuick 2.6
import QtQuick.Controls 2.3
import QtWebEngine 1.1
import QtWebChannel 1.0

import trinity.matrix 1.0

Popup {
    id: dialog

    width: parent.width / 1.2
    height: parent.height / 1.2

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    modal: true

    CallObject {
        id: call
        WebChannel.id: "call"

        onAnswer: matrix.answerCall(originatingRoom, callId, sdp)

        onHangup: {
            matrix.hangupCall(originatingRoom, callId)
            dialog.close()
        }
    }

    property var originatingRoom;
    property var callId;
    property var offerObject;
    property var from;

    property var offer: function(theirOfferObject) {
        offerObject = theirOfferObject;
        offerTimer.start()
    }

    Timer {
        id: offerTimer

        repeat: false
        interval: 500
        onTriggered: call.offer(offerObject, from)
    }

    WebEngineView {
        anchors.fill: parent

        userScripts: [
            WebEngineScript {
                sourceUrl: "qrc:/call.js"
            }
        ]

        webChannel: WebChannel {
            registeredObjects: call
        }

        url: "qrc:/call.html"

        onFeaturePermissionRequested: grantFeaturePermission(securityOrigin, feature, true)
    }
}
