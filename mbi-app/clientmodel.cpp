#include "clientmodel.h"

ClientModel::ClientModel(QObject *parent ) : QAbstractListModel(parent) {
    // fixme: get data from DB
    m_clients.append({ "Angel Hogan", "Chapel St. 368 ", "Clearwater" , "0311 1823993" });
    m_clients.append({ "Felicia Patton", "Annadale Lane 2", "Knoxville" , "0368 1244494" });
    m_clients.append({ "Grant Crawford", "Windsor Drive 34", "Riverdale" , "0351 7826892" });
    m_clients.append({ "Gretchen Little", "Sunset Drive 348", "Virginia Beach" , "0343 1234991" });
    m_clients.append({ "Geoffrey Richards", "University Lane 54", "Trussville" , "0423 2144944" });
    m_clients.append({ "Henrietta Chavez", "Via Volto San Luca 3", "Piobesi Torinese" , "0399 2826994" });
    m_clients.append({ "Harvey Chandler", "North Squaw Creek 11", "Madisonville" , "0343 1244492" });
    m_clients.append({ "Miguel Gomez", "Wild Rose Street 13", "Trussville" , "0343 9826996" });
    m_clients.append({ "Norma Rodriguez", " Glen Eagles Street  53", "Buffalo" , "0241 5826596" });
    m_clients.append({ "Shelia Ramirez", "East Miller Ave 68", "Pickerington" , "0346 4844556" });
    m_clients.append({ "Stephanie Moss", "Piazza Trieste e Trento 77", "Roata Chiusani" , "0363 0510490" });
}

int ClientModel::rowCount(const QModelIndex &) const {
    return m_clients.count();
}

QVariant ClientModel::data(const QModelIndex &index, int role) const {
    if (index.row() < rowCount())
        switch (role) {
        case FullNameRole: return m_clients.at(index.row()).fullName;
        case AddressRole: return m_clients.at(index.row()).address;
        case CityRole: return m_clients.at(index.row()).city;
        case NumberRole: return m_clients.at(index.row()).number;
        default: return QVariant();
    }
    return QVariant();
}

QHash<int, QByteArray> ClientModel::roleNames() const {
    static const QHash<int, QByteArray> roles {
        { FullNameRole, "fullName" },
        { AddressRole, "address" },
        { CityRole, "city" },
        { NumberRole, "number" }
    };
    return roles;
}

QVariantMap ClientModel::get(int row) const {
    const Client client = m_clients.value(row);
    return { {"fullName", client.fullName}, {"address", client.address}, {"city", client.city}, {"number", client.number} };
}

void ClientModel::append(const QString &fullName, const QString &address, const QString &city, const QString &number) {
    int row = 0;
    while (row < m_clients.count() && fullName > m_clients.at(row).fullName)
        ++row;
    beginInsertRows(QModelIndex(), row, row);
    m_clients.insert(row, {fullName, address, city, number});
    endInsertRows();
}

void ClientModel::set(int row, const QString &fullName, const QString &address, const QString &city, const QString &number) {
    if (row < 0 || row >= m_clients.count())
        return;

    m_clients.replace(row, { fullName, address, city, number });
    dataChanged(index(row, 0), index(row, 0), { FullNameRole, AddressRole, CityRole, NumberRole });
}

void ClientModel::remove(int row) {
    if (row < 0 || row >= m_clients.count())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_clients.removeAt(row);
    endRemoveRows();
}
