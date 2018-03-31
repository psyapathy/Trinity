#pragma once

#include <QSettings>

class Settings : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool showTypingNotifications READ getTypingNotifications WRITE setTypingNotifications NOTIFY typingNotificationsChanged)
    Q_PROPERTY(bool showReadAcknowledgements READ getReadAcknowledgements WRITE setReadAcknowledgements NOTIFY readAcknowledgementsChanged)
public:
    Settings() {
        QSettings settings;
        showTypingNotifications = settings.value("showTypingNotifications", true).toBool();
        showReadAcknowledgements = settings.value("showReadAcknowledgements", true).toBool();
    }

    Q_INVOKABLE void save() {
        QSettings settings;
        settings.setValue("showTypingNotifications", showTypingNotifications);
        settings.setValue("showReadAcknowledgements", showReadAcknowledgements);
    }

    void setTypingNotifications(const bool value) {
        showTypingNotifications = value;
        emit typingNotificationsChanged();

        save();
    }

    void setReadAcknowledgements(const bool value) {
        showReadAcknowledgements = value;
        emit readAcknowledgementsChanged();

        save();
    }

    bool getTypingNotifications() const {
        return showTypingNotifications;
    }

    bool getReadAcknowledgements() const {
        return showReadAcknowledgements;
    }

signals:
    void typingNotificationsChanged();
    void readAcknowledgementsChanged();

private:
    bool showTypingNotifications, showReadAcknowledgements;
};
