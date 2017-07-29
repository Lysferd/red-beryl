#ifndef DEVICEFINDER_H
#define DEVICEFINDER_H

#include "bluetooth.h"

#include <QTimer>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QVariant>

class DeviceFinder : public Bluetooth
{
public:
    DeviceFinder();
};

#endif // DEVICEFINDER_H
