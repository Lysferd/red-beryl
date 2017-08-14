#include "patientmodel.h"

PatientModel::PatientModel(QObject *parent ) : QAbstractListModel(parent) {
    // fixme: get data from DB
    m_patients.append({ "Angel Hogan", "Chapel St. 368 ", "Clearwater" , "0311 1823993" });
    m_patients.append({ "Felicia Patton", "Annadale Lane 2", "Knoxville" , "0368 1244494" });
    m_patients.append({ "Grant Crawford", "Windsor Drive 34", "Riverdale" , "0351 7826892" });
    m_patients.append({ "Gretchen Little", "Sunset Drive 348", "Virginia Beach" , "0343 1234991" });
    m_patients.append({ "Geoffrey Richards", "University Lane 54", "Trussville" , "0423 2144944" });
    m_patients.append({ "Henrietta Chavez", "Via Volto San Luca 3", "Piobesi Torinese" , "0399 2826994" });
    m_patients.append({ "Harvey Chandler", "North Squaw Creek 11", "Madisonville" , "0343 1244492" });
    m_patients.append({ "Miguel Gomez", "Wild Rose Street 13", "Trussville" , "0343 9826996" });
    m_patients.append({ "Norma Rodriguez", " Glen Eagles Street  53", "Buffalo" , "0241 5826596" });
    m_patients.append({ "Shelia Ramirez", "East Miller Ave 68", "Pickerington" , "0346 4844556" });
    m_patients.append({ "Stephanie Moss", "Piazza Trieste e Trento 77", "Roata Chiusani" , "0363 0510490" });
}

int PatientModel::rowCount(const QModelIndex &) const {
    return m_patients.count();
}

QVariant PatientModel::data(const QModelIndex &index, int role) const {
    if (index.row() < rowCount())
        switch (role) {
        case FullNameRole: return m_patients.at(index.row()).fullName;
        case AddressRole: return m_patients.at(index.row()).address;
        case CityRole: return m_patients.at(index.row()).city;
        case NumberRole: return m_patients.at(index.row()).number;
        default: return QVariant();
    }
    return QVariant();
}

QHash<int, QByteArray> PatientModel::roleNames() const {
    static const QHash<int, QByteArray> roles {
        { FullNameRole, "fullName" },
        { AddressRole, "address" },
        { CityRole, "city" },
        { NumberRole, "number" }
    };
    return roles;
}

QVariantMap PatientModel::get(int row) const {
    const Patient patient = m_patients.value(row);
    return { {"fullName", patient.fullName}, {"address", patient.address}, {"city", patient.city}, {"number", patient.number} };
}

void PatientModel::append(const QString &fullName, const QString &address, const QString &city, const QString &number) {
    int row = 0;
    while (row < m_patients.count() && fullName > m_patients.at(row).fullName)
        ++row;
    beginInsertRows(QModelIndex(), row, row);
    m_patients.insert(row, {fullName, address, city, number});
    endInsertRows();
}

void PatientModel::set(int row, const QString &fullName, const QString &address, const QString &city, const QString &number) {
    if (row < 0 || row >= m_patients.count())
        return;

    m_patients.replace(row, { fullName, address, city, number });
    dataChanged(index(row, 0), index(row, 0), { FullNameRole, AddressRole, CityRole, NumberRole });
}

void PatientModel::remove(int row) {
    if (row < 0 || row >= m_patients.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_patients.removeAt(row);
    endRemoveRows();
}
