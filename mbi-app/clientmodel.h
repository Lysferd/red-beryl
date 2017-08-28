#ifndef CLIENTMODEL_H
#define CLIENTMODEL_H

#include <QAbstractItemModel>

class ClientModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum ClientRole {
        FullNameRole = Qt::DisplayRole,
        AddressRole = Qt::UserRole,
        CityRole,
        NumberRole
    };
    Q_ENUM(ClientRole)

    ClientModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void append(const QString &fullName, const QString &address, const QString  &city, const QString &number);
    Q_INVOKABLE void set(int row, const QString &fullName, const QString &address, const QString  &city, const QString &number);
    Q_INVOKABLE void remove(int row);

private:
    struct Client {
        QString fullName;
        QString address;
        QString city;
        QString number;
    };

    QList<Client> m_clients;
};

#endif // CLIENTMODEL_H
