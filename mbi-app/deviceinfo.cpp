#include "deviceinfo.h"

#include <QBluetoothAddress>
#include <QBluetoothUuid>

DeviceInfo::DeviceInfo(const QBluetoothDeviceInfo &device) :
    QObject(), m_device(device) { }

QBluetoothDeviceInfo DeviceInfo::getDevice() const {
    return m_device;
}

QString DeviceInfo::getName() const {
    return m_device.name();
}

QString DeviceInfo::getAddress() const {
#ifdef Q_OS_DARWIN
    // Core Bluetooth workaround.
    return m_device.deviceUuid().toString();
#else
    return m_device.address().toString();
#endif
}

void DeviceInfo::setDevice(const QBluetoothDeviceInfo &device) {
    m_device = device;
    emit deviceChanged();
}
