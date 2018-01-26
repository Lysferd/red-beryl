//
//  BTDiscovery.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/24.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation
import CoreBluetooth

let btDiscoverySharedInstance = BTDiscovery();

class BTDiscovery: NSObject, CBCentralManagerDelegate {

  fileprivate var centralManager: CBCentralManager?
  fileprivate var peripheralBLE: CBPeripheral?

  override init() {
    super.init()

    let centralQueue = DispatchQueue(label: "com.raywenderlich", attributes: [])
    centralManager = CBCentralManager(delegate: self, queue: centralQueue)

    NSLog("Discovery initialized")
  }

  func startScanning() {
    NSLog( "Started scanning" )

    if let central = centralManager {
      central.scanForPeripherals(withServices: nil)
    }

  }

  var bleService: BTService? {
    didSet {
      if let service = self.bleService {
        service.startDiscoveringServices()
      }
    }
  }

  // MARK: - CBCentralManagerDelegate

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    // Be sure to retain the peripheral or it will fail during connection.

    // Validate peripheral information
    //if ((peripheral.name == nil) || (peripheral.name == "")) {
    //  return
    //}

    NSLog("Found device: %@ [\(peripheral.identifier)]", peripheral.name ?? "NIL")
    NSLog("Advertisement data: %@", advertisementData)

    // If not already connected to a peripheral, then connect to this one
    return

    if ((self.peripheralBLE == nil) || (self.peripheralBLE?.state == CBPeripheralState.disconnected)) {
      // Retain the peripheral before trying to connect
      self.peripheralBLE = peripheral

      // Reset service
      self.bleService = nil

      NSLog("Attempting connection with %@", self.peripheralBLE?.name ?? "NIL")

      // Connect to peripheral
      central.connect(peripheral, options: nil)
    }
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

    NSLog("Connection succeeded with %@", self.peripheralBLE?.name ?? "NIL")

    // Create new service class
    if (peripheral == self.peripheralBLE) {
      self.bleService = BTService(initWithPeripheral: peripheral)
    }

    // Stop scanning for new devices
    central.stopScan()
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

    // See if it was our peripheral that disconnected
    if (peripheral == self.peripheralBLE) {
      self.bleService = nil;
      self.peripheralBLE = nil;
    }

    // Start scanning for new devices
    self.startScanning()
  }

  // MARK: - Private

  func clearDevices() {
    self.bleService = nil
    self.peripheralBLE = nil
  }

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch (central.state) {
    case .poweredOff:
      self.clearDevices()

    case .unauthorized:
      // Indicate to user that the iOS device does not support BLE.
      break

    case .unknown:
      // Wait for another event
      break

    case .poweredOn:
      self.startScanning()

    case .resetting:
      self.clearDevices()

    case .unsupported:
      break
    }
  }

}

