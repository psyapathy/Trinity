var currentOffer, callObject, currentMember;

function setCallStatus(status) {
    document.getElementById("call_status").innerHTML = status;
}

function answer() {
    var peerConnection = new RTCPeerConnection();
    var desc = new RTCSessionDescription(currentOffer);

    peerConnection.setRemoteDescription(desc).then(function() {
        setCallStatus("Setting up streams...")
        return navigator.mediaDevices.getUserMedia({audio: true});
    }).then(function(stream) {
        peerConnection.addStream(stream);
    }).then(function() {
        setCallStatus("Contacting " + currentMember + "....")
        return peerConnection.createAnswer();
    }).then(function(answer) {
        return peerConnection.setLocalDescription(answer);
    }).then(function() {
        callObject.answerCall(peerConnection.localDescription)
        setCallStatus("In call with " + currentMember)
    });
}

function hangup() {
    callObject.hangupCall()
}

document.addEventListener("DOMContentLoaded", function () {
    new QWebChannel(qt.webChannelTransport, function (channel) {
        var call = channel.objects.call;
        callObject = call

        call.offer.connect(function (offer, member) {
            currentOffer = offer
            currentMember = member

            setCallStatus("Call from " + member)
        });
    });
});
