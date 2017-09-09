#include "clientmodel.h"

ClientModel::ClientModel(QObject *parent) : QAbstractListModel(parent) {
    // fixme: get data from DB

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("fontanario.sqlite");
    /*
    if (!db.open())
        return db.lastError();

    QStringList tables = db.tables();
    QSqlQuery query;
    if (!tables.contains("clients", Qt::CaseInsensitive)) {
        if (!query.exec((QLatin1String("create table clients(title varchar, author varchar)"))))
            return query.lastError();
    }
    */

    // append fake data for kicks
    m_clients.append({ "123456", "Grey", "Derpy", "Vilkerness", "77777777777", "01/01/1980", "1234567890", "mail@mail.com", "Rua 1, 512, GG Izy", "Peasy City", "Squeazy State", "Lemonade", "O+", "CardÃ­aco, HipertensÃ£o", "Furosemida, Dalteparina SÃ³dica", "01/01/2001", "15/15/2015", "15/05/2017" });

    m_clients.append({ "443456", "Meleca", "de", "Narizes", "93977777777", "01/01/1990", "41997755443", "baleia@fedor.com", "Rua abacate, 512, GG Izy", "verde City", "orelha estadual", "Lemonade", "AB+", "Gordocaralho, Febre, Filhadaputisse", "Frescurol, Cebola em Pow", "01/01/2001", "15/15/2015", "15/05/2017" });
}

int ClientModel::rowCount(const QModelIndex &) const {
    return m_clients.count();
}

QVariant ClientModel::data(const QModelIndex &index, int role) const {
    if (index.row() < rowCount()) {
        Client c = m_clients.at(index.row());

        switch (role) {
            case FullNameRole: return c.firstName + " " + c.lastName;
            case RecordRole: return c.record;
            case FirstNameRole: return c.firstName;
            case MiddleNameRole: return c.middleName;
            case LastNameRole: return c.lastName;
            case PersonalIdRole: return c.personalId;
            case BirthDateRole: return c.birthDate;
            case PhoneNumberRole: return c.phoneNumber;
            case EmailRole: return c.email;
            case AddressRole: return c.address;
            case CityRole: return c.city;
            case StateRole: return c.state;
            case CountryRole: return c.country;
            case BloodTypeRole: return c.bloodType;
            case RiskGroupsRole: return c.riskGroups;
            case RegularMedicinesRole: return c.regularMedicines;
            case RegisterDateRole: return c.registerDate;
            case UpdateDateRole: return c.updateDate;
            case LastConsultationRole: return c.lastConsultation;
            default: return QVariant();
        }
    }

    return QVariant();
}

QHash<int, QByteArray> ClientModel::roleNames() const {
    static const QHash<int, QByteArray> roles {
        { FullNameRole, "fullName" },
        { RecordRole, "record" },
        { FirstNameRole, "firstName" },
        { MiddleNameRole, "middleName" },
        { LastNameRole, "lastName" },
        { PersonalIdRole, "personalId" },
        { BirthDateRole, "birthDate" },
        { PhoneNumberRole, "phoneNumber" },
        { EmailRole, "email" },
        { AddressRole, "address" },
        { CityRole, "city" },
        { StateRole, "state" },
        { CountryRole, "country" },
        { BloodTypeRole, "bloodType" },
        { RiskGroupsRole, "riskGroups" },
        { RegularMedicinesRole, "regularMedicines" },
        { RegisterDateRole, "registerDate" },
        { UpdateDateRole, "updateDate" },
        { LastConsultationRole, "lastConsultation" }
    };
    return roles;
}

QVariantMap ClientModel::get(int row) const {
    const Client client = m_clients.value(row);

    return {
             {"fullName", client.firstName + " " + client.lastName },
             {"record", client.record},
             {"firstName", client.firstName},
             {"middleName", client.middleName},
             {"lastName", client.lastName},
             {"personalId", client.personalId},
             {"birthDate", client.birthDate},
             {"phoneNumber", client.phoneNumber},
             {"email", client.email},
             {"address", client.address},
             {"city", client.city},
             {"state", client.state},
             {"country", client.country},
             {"bloodType", client.bloodType},
             {"riskGroups", client.riskGroups},
             {"regularMedicines", client.regularMedicines},
             {"registerDate", client.registerDate},
             {"updateDate", client.updateDate},
             {"lastConsultation", client.lastConsultation}
    };
}

void ClientModel::append(const QString &record, const QString &firstName, const QString &middleName, const QString &lastName, const QString &personalId, const QString &birthDate, const QString &phoneNumber, const QString &email, const QString &address, const QString &city, const QString &state, const QString &country, const QString &bloodType, const QString &riskGroups, const QString &regularMedicines, const QString &registerDate, const QString &updateDate, const QString &lastConsultation) {
    int row = m_clients.count();

    beginInsertRows(QModelIndex(), row, row);
    m_clients.append({ record, firstName, middleName, lastName, personalId,
                       birthDate, phoneNumber, email, address, city, state,
                       country, bloodType, riskGroups, regularMedicines,
                       registerDate, updateDate, lastConsultation });
    endInsertRows();
}

void ClientModel::set(int row, const QString &record, const QString &firstName, const QString &middleName, const QString &lastName, const QString &personalId, const QString &birthDate, const QString &phoneNumber, const QString &email, const QString &address, const QString &city, const QString &state, const QString &country, const QString &bloodType, const QString &riskGroups, const QString &regularMedicines, const QString &registerDate, const QString &updateDate, const QString &lastConsultation) {
    if (row < 0 || row >= m_clients.count())
        return;

    m_clients.replace(row, { record, firstName, middleName, lastName, personalId,
                             birthDate, phoneNumber, email, address, city, state,
                             country, bloodType, riskGroups, regularMedicines,
                             registerDate, updateDate, lastConsultation });
    dataChanged(index(row, 0), index(row, 0), { FullNameRole,
                                                RecordRole,
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
                                                LastConsultationRole });
}

void ClientModel::remove(int row) {
    if (row < 0 || row >= m_clients.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_clients.removeAt(row);
    endRemoveRows();
}
