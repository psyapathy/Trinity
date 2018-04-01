#pragma once

#include <QSettings>

class Settings : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool showTypingNotifications READ getTypingNotifications WRITE setTypingNotifications NOTIFY typingNotificationsChanged)
    Q_PROPERTY(bool showReadAcknowledgements READ getReadAcknowledgements WRITE setReadAcknowledgements NOTIFY readAcknowledgementsChanged)
    Q_PROPERTY(QString accentColor READ getAccentColor WRITE setAccentColor NOTIFY accentColorChanged)
public:
    Settings() {
        QSettings settings;
        showTypingNotifications = settings.value("showTypingNotifications", true).toBool();
        showReadAcknowledgements = settings.value("showReadAcknowledgements", true).toBool();
        accentColor = settings.value("accentColor", "#1e74fd").toString();
    }

    Q_INVOKABLE void save() {
        QSettings settings;
        settings.setValue("showTypingNotifications", showTypingNotifications);
        settings.setValue("showReadAcknowledgements", showReadAcknowledgements);
        settings.setValue("accentColor", accentColor);
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

    void setAccentColor(const QString color) {
        accentColor = color;
        emit accentColorChanged();
    }

    bool getTypingNotifications() const {
        return showTypingNotifications;
    }

    bool getReadAcknowledgements() const {
        return showReadAcknowledgements;
    }

    QString getAccentColor() const {
        return accentColor;
    }

signals:
    void typingNotificationsChanged();
    void readAcknowledgementsChanged();
    void accentColorChanged();

private:
    bool showTypingNotifications, showReadAcknowledgements;
    QString accentColor;
};
