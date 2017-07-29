#include "bluetooth.h"

Bluetooth::Bluetooth(QObject *parent) : QObject(parent) { }

QString Bluetooth::error() const {
    return m_error;
}

QString Bluetooth::info() const {
    return m_info;
}

void Bluetooth::setError(const QString &error) {
    if (m_error != error) {
        m_error = error;
        emit errorChanged();
    }
}

void Bluetooth::setInfo(const QString &info) {
    if (m_info != info) {
        m_info = info;
        emit infoChanged();
    }
}

void Bluetooth::clearMessages() {
    setInfo("");
    setError("");
}
