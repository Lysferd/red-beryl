#ifndef CLIENTMODEL_H
#define CLIENTMODEL_H

#define COLUMNS const QString &record, const QString &firstName, const QString &middleName, const QString &lastName, const QString &personalId, const QString &birthDate, const QString &phoneNumber, const QString &email, const QString &address, const QString &city, const QString &state, const QString &country, const QString &bloodType, const QString &riskGroups, const QString &regularMedicines, const QString &registerDate, const QString &updateDate, const QString &lastConsultation

#include <QtSql>
#include <QSqlQueryModel>

class ClientModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    enum ClientRole {
        FullNameRole = Qt::DisplayRole,
        FirstLetter,
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
    int rowCount(const QModelIndex & = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE QVariantMap get(int row) const;

    /*
    Q_INVOKABLE void append(COLUMNS);

    Q_INVOKABLE void set(COLUMNS);

    Q_INVOKABLE void remove(int row);
    */

private:
    QSqlDatabase m_db;

    QString create_table = QLatin1String("create table clients(record varchar, firstName varchar, middleName varchar, lastName varchar, personalId varchar, birthData varchar, phoneNumber varchar, email varchar, address varchar, city varchar, state varchar, country varchar, bloodType varchar, riskGroups varchar, regularMedicines varchar, registerDate varchar, updateDate varchar, lastConsultation varchar)");
    QString insert = QLatin1String("insert into clients(record, firstName, middleName, lastName, personalId, birthData, phoneNumber, email, address, city, state, country, bloodType, riskGroups, regularMedicines, registerDate, updateDate, lastConsultation) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    QString count_query = QLatin1String("SELECT COUNT(*) FROM clients");
    QString select_query = QLatin1String("SELECT record, firstName, middleName, lastName, personalId, birthData, phoneNumber, email, address, city, state, country, bloodType, riskGroups, regularMedicines, registerDate, updateDate, lastConsultation FROM clients WHERE rowid = (:row)");
};

#endif // CLIENTMODEL_H
