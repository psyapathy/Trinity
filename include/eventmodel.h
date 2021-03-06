#pragma once

#include <QAbstractListModel>

class MatrixCore;
struct Room;
class Event;

class EventModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum EventRoles {
        CondenseRole = Qt::UserRole + 1,
        NextCondenseRole,
        TimestampRole
    };

    EventModel(MatrixCore& matrix);

    int rowCount(const QModelIndex &parent) const override;

    QVariant data(const QModelIndex &index, int role) const override;

    void beginUpdate(const unsigned int num);

    void endUpdate() {
        if(room)
            endInsertRows();
    }

    void beginHistory(int size);

    void endHistory() {
        if(room)
            endInsertRows();
    }

    void setRoom(Room* room);

    void fullUpdate() {
        emit layoutChanged();
    }

    void beginRemoveEvent(int offset, int size) {
        beginRemoveRows(QModelIndex(), offset, offset + size);
    }

    void endRemoveEvent() {
        endRemoveRows();
    }

    void updateEvent(const Event* event);
    void updateEventsByMember(const QString& id);

protected:
    QHash<int, QByteArray> roleNames() const override;

    Room* room = nullptr;
    MatrixCore& matrix;
};
