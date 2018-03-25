#pragma once

#include <QObject>
#include <QJsonObject>
#include <QJsonValue>

class CallObject : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE void answerCall(QJsonValue sdp) {
        emit answer(sdp);
    }

    Q_INVOKABLE void hangupCall() {
        emit hangup();
    }

signals:
    void offer(QJsonObject sdp, QString from);
    void answer(QJsonValue sdp);
    void hangup();
};
