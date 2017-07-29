#include "devicehandler.h"
#include "deviceinfo.h"

#include <QtEndian>
<<<<<<< HEAD
/*
=======

>>>>>>> c2a8a16df58f9a0376f849063f31e2f8d0626922
DeviceHandler::DeviceHandler(QObject *parent) :
    Bluetooth(parent),
    m_control(0),
    m_service(0),
    m_currentDevice(0),
    m_foundHeartRateService(false),
    m_measuring(false),
    m_currentValue(0),
    m_min(0), m_max(0), m_sum(0), m_avg(0), m_calories(0) {

}

void DeviceHandler::setAddressType(AddressType type) {
    switch (type) {
    case DeviceHandler::AddressType::PublicAddress:
        m_addressType = QLowEnergyController::PublicAddress;
        break;
    case DeviceHandler::AddressType::RandomAddress:
        m_addressType = QLowEnergyController::RandomAddress;
        break;
    }
}

DeviceHandler::AddressType DeviceHandler::addressType() const {
    if (m_addressType == QLowEnergyController::RandomAddress)
        return DeviceHandler::AddressType::RandomAddress;

    return DeviceHandler::AddressType::PublicAddress;
}

void DeviceHandler::setDevice(DeviceInfo *device) {
    clearMessages();
    m_currentDevice = device;

<<<<<<< HEAD
    /*
=======
>>>>>>> c2a8a16df58f9a0376f849063f31e2f8d0626922
    if (m_control) {
        m_control->disconnectFromDevice();
        delete m_control;
        m_control = 0;
    }

    if (m_currentDevice) {
        m_control = new QLowEnergyController(m_currentDevice->getDevice(), this);
        m_control->setRemoteAddressType(m_addressType);
        connect(m_control, &QLowEnergyController::serviceDiscovered,
                this, &DeviceHandler::serviceDiscovered);
        connect(m_control, &QLowEnergyController::discoveryFinished,
                this, &DeviceHandler::serviceScanDone);

        connect(m_control,
                static_cast<void (QLowEnergyController::*)(QLowEnergyController::Error)>(&QLowEnergyController::error),
                this, [this](QLowEnergyController::Error error) {
            Q_UNUSED(error);
            setError("Cannot connect to remote device");
        });

        connect(m_control, &QLowEnergyController::connected, this,
                [this]() {
            setInfo("Controller connected. Search devices...");
            m_control->discoverServices();
        });

        connect(m_control, &QLowEnergyController::disconnected, this,
                [this]() {
            setError("LowEnergy controller disconnected.");
        });

        m_control->connectToDevice();
    }
<<<<<<< HEAD

}


void DeviceHandler::startMeasurement() {
    /*
=======
}

void DeviceHandler::startMeasurement() {
>>>>>>> c2a8a16df58f9a0376f849063f31e2f8d0626922
    if (alive()) {
        m_start = QDateTime::currentDateTime();
        m_min = 0;
        m_max = 0;
        m_avg = 0;
        m_sum = 0;
        m_calories = 0;
        m_measuring = false;
        m_measurements.clear();
        emit measuringChanged();
    }
<<<<<<< HEAD

=======
>>>>>>> c2a8a16df58f9a0376f849063f31e2f8d0626922
}

void DeviceHandler::stopMeasurement() {
    m_measuring = false;
    emit measuringChanged();
}
<<<<<<< HEAD
*/
=======
>>>>>>> c2a8a16df58f9a0376f849063f31e2f8d0626922

