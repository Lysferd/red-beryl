#include "devicefinder.h"
#include "devicehandler.h"
#include "deviceinfo.h"

DeviceFinder::DeviceFinder(DeviceHandler *handler, QObject *parent):
    Bluetooth(parent),
    m_deviceHandler(handler)
{
    //! [devicediscovery-1]
    m_deviceDiscoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    m_deviceDiscoveryAgent->setLowEnergyDiscoveryTimeout(5000);

    connect(m_deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &DeviceFinder::addDevice);
    connect(m_deviceDiscoveryAgent, static_cast<void (QBluetoothDeviceDiscoveryAgent::*)(QBluetoothDeviceDiscoveryAgent::Error)>(&QBluetoothDeviceDiscoveryAgent::error),
            this, &DeviceFinder::scanError);

    connect(m_deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &DeviceFinder::scanFinished);
    connect(m_deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::canceled, this, &DeviceFinder::scanFinished);
    //! [devicediscovery-1]
}

DeviceFinder::~DeviceFinder()
{
    qDeleteAll(m_devices);
    m_devices.clear();
}

void DeviceFinder::startSearch()
{
    clearMessages();
    m_deviceHandler->setDevice(0);
    qDeleteAll(m_devices);
    m_devices.clear();

    emit devicesChanged();

    //! [devicediscovery-2]
    m_deviceDiscoveryAgent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
    //! [devicediscovery-2]
    //!
    emit scanningChanged();
    setInfo(tr("Scanning for devices..."));
}

//! [devicediscovery-3]
void DeviceFinder::addDevice(const QBluetoothDeviceInfo &device)
{
    // If device is LowEnergy-device, add it to the list
    if (device.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        m_devices.append(new DeviceInfo(device));
        setInfo(tr("Low Energy device found. Scanning more..."));
//! [devicediscovery-3]
        emit devicesChanged();
//! [devicediscovery-4]
    }
    //...
}
//! [devicediscovery-4]

void DeviceFinder::scanError(QBluetoothDeviceDiscoveryAgent::Error error)
{
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError)
        setError(tr("The Bluetooth adaptor is powered off."));
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
        setError(tr("Writing or reading from the device resulted in an error."));
    else
        setError(tr("An unknown error has occurred."));
}

void DeviceFinder::scanFinished()
{
    if (m_devices.size() == 0)
        setError(tr("No Low Energy devices found."));
    else
        setInfo(tr("Scanning done."));

    emit scanningChanged();
    emit devicesChanged();
}

void DeviceFinder::connectToService(const QString &address)
{
    m_deviceDiscoveryAgent->stop();

    DeviceInfo *currentDevice = 0;
    for (int i = 0; i < m_devices.size(); i++) {
        if (((DeviceInfo*)m_devices.at(i))->getAddress() == address ) {
            currentDevice = (DeviceInfo*)m_devices.at(i);
            break;
        }
    }

    if (currentDevice)
        m_deviceHandler->setDevice(currentDevice);

    clearMessages();
}

bool DeviceFinder::scanning() const
{
    return m_deviceDiscoveryAgent->isActive();
}

QVariant DeviceFinder::devices()
{
    return QVariant::fromValue(m_devices);
}
