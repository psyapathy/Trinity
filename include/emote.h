#pragma once

#include <QString>

class Emote : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString path READ getPath WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
public:
    void setPath(const QString& path) {
        this->path = path;
        emit pathChanged();
    }

    void setName(const QString& name) {
        this->name = name;
        emit nameChanged();
    }

    QString getPath() const {
        return path;
    }

    QString getName() const {
        return name;
    }

private:
    QString path, name;

signals:
    void nameChanged();
    void pathChanged();
};
