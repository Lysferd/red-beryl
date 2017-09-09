#ifndef CLIENTMODEL_H
#define CLIENTMODEL_H

#include <QAbstractItemModel>
#include <QtSql>
#include <QSqlQueryModel>

# define a

class ClientModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum ClientRole {
        FullNameRole = Qt::DisplayRole,
        RecordRole = Qt::UserRole,
        FirstNameRole,
        MiddleNameRole,
        LastNameRole,
        PersonalIdRole,
        BirthDateRole,
        PhoneNumberRole,
        EmailRole,
        AddressRole,
        CityRole,
        StateRole,
        CountryRole,
        BloodTypeRole,
        RiskGroupsRole,
        RegularMedicinesRole,
        RegisterDateRole,
        UpdateDateRole,
        LastConsultationRole
    };
    Q_ENUM(ClientRole)

    ClientModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void append(const QString &record, const QString &firstName, const QString &middleName, const QString &lastName, const QString &personalId, const QString &birthDate, const QString &phoneNumber, const QString &email, const QString &address, const QString &city, const QString &state, const QString &country, const QString &bloodType, const QString &riskGroups, const QString &regularMedicines, const QString &registerDate, const QString &updateDate, const QString &lastConsultation);
    Q_INVOKABLE void set(int row, const QString &record, const QString &firstName, const QString &middleName, const QString &lastName, const QString &personalId, const QString &birthDate, const QString &phoneNumber, const QString &email, const QString &address, const QString &city, const QString &state, const QString &country, const QString &bloodType, const QString &riskGroups, const QString &regularMedicines, const QString &registerDate, const QString &updateDate, const QString &lastConsultation);
    Q_INVOKABLE void remove(int row);

private:
    struct Client {
        QString record;
        QString firstName;
        QString middleName;
        QString lastName;
        QString personalId;
        QString birthDate;
        QString phoneNumber;
        QString email;
        QString address;
        QString city;
        QString state;
        QString country;
        QString bloodType;
        QString riskGroups;
        QString regularMedicines;
        QString registerDate;
        QString updateDate;
        QString lastConsultation;
    };

    QList<Client> m_clients;
};

#endif // CLIENTMODEL_H
