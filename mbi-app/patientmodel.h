#ifndef PATIENTMODEL_H
#define PATIENTMODEL_H

#include <QAbstractItemModel>

class PatientModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum PatientRole {
        FullNameRole = Qt::DisplayRole,
        AddressRole = Qt::UserRole,
        CityRole,
        NumberRole
    };
    Q_ENUM(PatientRole)

    PatientModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void append(const QString &fullName, const QString &address, const QString  &city, const QString &number);
    Q_INVOKABLE void set(int row, const QString &fullName, const QString &address, const QString  &city, const QString &number);
    Q_INVOKABLE void remove(int row);

private:
    struct Patient {
        QString fullName;
        QString address;
        QString city;
        QString number;
    };

    QList<Patient> m_patients;
};

#endif // PATIENTMODEL_H
