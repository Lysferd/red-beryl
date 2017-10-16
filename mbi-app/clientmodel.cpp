#include "clientmodel.h"

ClientModel::ClientModel(QObject *parent) : QSqlQueryModel(parent) {

    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName("fontanario.sqlite");

    if (!m_db.open()) {
        qCritical() << "Could not open database.";
        throw m_db.lastError();
    }

    QSqlQuery query;
    QStringList tables = m_db.tables();
    if (!tables.contains("clients", Qt::CaseInsensitive)) {
        qInfo() << "Table `clients` not found. Attempting to create it.";

        if (!query.exec(create_table)) {
            qCritical() << "Could not create table `clients`.";
            throw query.lastError();
        }
    }

    /*
    if (!query.prepare(insert))
        throw query.lastError();

    auto add = [&] (const QString &record, const QString &firstName, const QString &middleName, const QString &lastName, const QString &personalId, const QString &birthDate, const QString &phoneNumber, const QString &email, const QString &address, const QString &city, const QString &state, const QString &country, const QString &bloodType, const QString &riskGroups, const QString &regularMedicines, const QString &registerDate, const QString &updateDate, const QString &lastConsultation) {
        query.addBindValue(record);
        query.addBindValue(firstName);
        query.addBindValue(middleName);
        query.addBindValue(lastName);
        query.addBindValue(personalId);
        query.addBindValue(birthDate);
        query.addBindValue(phoneNumber);
        query.addBindValue(email);
        query.addBindValue(address);
        query.addBindValue(city);
        query.addBindValue(state);
        query.addBindValue(country);
        query.addBindValue(bloodType);
        query.addBindValue(riskGroups);
        query.addBindValue(regularMedicines);
        query.addBindValue(registerDate);
        query.addBindValue(updateDate);
        query.addBindValue(lastConsultation);
        query.exec();
    };

    add("123456", "Antonio", "José", "Vilkerness", "77777777777", "01/01/1980", "1234567890", "mail@mail.com", "Rua 1, 512, GG Izy", "Peasy City", "Squeazy State", "Lemonade", "O+", "Cardi­aco, Hipertensao", "Furosemida, Dalteparina Sodica", "01/01/2001", "15/15/2015", "15/05/2017");

    add("443456", "Bruno", "de", "Souza", "93977777777", "01/01/1990", "41997755443", "mail@mail.com", "Rua KK, 512, GG Izy", "verde City", "Estrada estadual", "Lemonade", "AB+", "Obesidade, Febre, Bipolar", "Diasepan, Dipirona", "01/01/2001", "15/15/2015", "15/05/2017");

    add("992313", "Carlos", "", "Mendes", "32817257777", "05/03/1975", "31227755443", "mail@mail.com", "Rua abacate, 512, Nadd", "verde City", "orelha estadual", "Lemonade", "AB-", "", "Metileno", "01/01/2001", "15/15/2015", "15/05/2017");

    add("522313", "Daniele", "Silva", "Oliveira", "32817257777", "05/03/1975", "31227755443", "mail@mail.com", "Rua José Wool, 45, 512, Cais", "Calhoça", "Parque estadual", "Lemonade", "B-", "Sopro Cardiaco, Diabetes", "Etileno, Insulina", "01/01/2001", "15/15/2015", "15/05/2017");

    add("772313", "Eduardo", "Andrew", "Monsanto", "32817257777", "05/03/1975", "31227755443", "mail@mail.com", "Rua Árvore de Natal, 25, Dezz", "Panolo City", "Colabb", "Lemonade", "O-", "Esquizofrenia", "Ritalina, Tiroxina", "01/01/2001", "15/15/2015", "15/05/2017");
    */
}

int ClientModel::rowCount(const QModelIndex &) const {
    QSqlQuery query;
    if (query.exec(count_query) && query.first())
        return query.value(0).toInt();
    throw query.lastError();
    qDebug() << query.executedQuery() << "=" << query.value(0).toString().toInt();
}

QVariant ClientModel::data(const QModelIndex &index, int role) const {
    qDebug() << "data" << index << role;

    if (index.row() < rowCount()) {
        QSqlQuery query;
        query.prepare(select_query);
        query.bindValue(":row", index.row());
        if (query.exec() && query.first()) {
            qDebug() << query.value("firstName").toString() + query.value("lastName").toString()
                     << query.value("firstName").toString().at(0)
                     << query.value("record").toString()
                     << query.value("firstName").toString()
                     << query.value("personalId").toString();

            switch (role) {
            case FullNameRole:
                return query.value("firstName").toString() + query.value("lastName").toString();
            case FirstLetter:
                return "A"; // query.value("firstName").toString().at(0);
            case RecordRole:
                return query.value("record").toString();
            case FirstNameRole:
                return query.value("firstName").toString();
            case MiddleNameRole:
                return query.value("middleName").toString();
            case LastNameRole:
                return query.value("lastName").toString();
            case PersonalIdRole:
                return query.value("personalId").toString();
            case BirthDateRole:
                return query.value("birthDate").toString();
            case PhoneNumberRole:
                return query.value("phoneNumber").toString();
            case EmailRole:
                return query.value("email").toString();
            case AddressRole:
                return query.value("address").toString();
            case CityRole:
                return query.value("city").toString();
            case StateRole:
                return query.value("state").toString();
            case CountryRole:
                return query.value("country").toString();
            case BloodTypeRole:
                return query.value("bloodType").toString();
            case RiskGroupsRole:
                return query.value("riskGroups").toString();
            case RegularMedicinesRole:
                return query.value("regularMedicines").toString();
            case RegisterDateRole:
                return query.value("registerDate").toString();
            case UpdateDateRole:
                return query.value("updateDate").toString();
            case LastConsultationRole:
                return query.value("lastConsultation").toString();
            default: return QVariant();
            }
        }
    }
    return QVariant();
}

QHash<int, QByteArray> ClientModel::roleNames() const {
    qDebug() << "roleNames";

    static const QHash<int, QByteArray> roles {
        { FullNameRole, "fullName" },
        { FirstLetter, "firstLetter"},
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
    qDebug() << "get" << row;

    QSqlQuery query;
    query.prepare(select_query);
    query.bindValue(":row", row);
    if (query.exec() && query.first()) {
        qDebug() << query.value("firstName").toString() + query.value("lastName").toString()
                 << query.value("firstName").toString().at(0)
                 << query.value("record").toString()
                 << query.value("firstName").toString()
                 << query.value("personalId").toString();

        return { { "fullName", query.value("firstName").toString() + query.value("lastName").toString() },
            { "firstLetter", "G" }, //query.value("firstName").toString().at(0) },
            { "record", query.value("record").toString() },
            { "firstName", query.value("firstName").toString() },
            { "middleName", query.value("middleName").toString() },
            { "lastName", query.value("lastName").toString() },
            { "personalId", query.value("personalId").toString() },
            { "birthDate", query.value("birthDate").toString() },
            { "phoneNumber", query.value("phoneNumber").toString() },
            { "email", query.value("email").toString() },
            { "address", query.value("address").toString() },
            { "city", query.value("city").toString() },
            { "state", query.value("state").toString() },
            { "country", query.value("country").toString() },
            { "bloodType", query.value("bloodType").toString() },
            { "riskGroups", query.value("riskGroups").toString() },
            { "regularMedicines", query.value("regularMedicines").toString() },
            { "registerDate", query.value("registerDate").toString() },
            { "updateDate", query.value("updateDate").toString() },
            { "lastConsultation", query.value("lastConsultation").toString() } };
    }
}
