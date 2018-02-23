//
//  BTDiscovery.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/24.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation
import CoreBluetooth

// MARK: Shared Instance
let btDiscoverySharedInstance = BTDiscovery()

// MARK: Notifications
let BLEScanning = NSNotification.Name("BLEScanning")
let BLEFound = Notification.Name("BLEFound")
let BLEConnected = NSNotification.Name("BLEConnected")

class BTDiscovery: NSObject, CBCentralManagerDelegate {

  // MARK: - Private Variables
  fileprivate var queue: DispatchQueue?
  fileprivate var centralManager: CBCentralManager?
  fileprivate var peripheral: CBPeripheral?

  var service: BTService?

  // MARK: - Initialization
  override init() {
    super.init()

    queue = DispatchQueue(label: "eng.moritzalmeida")
    centralManager = CBCentralManager(delegate: self, queue: queue)
  }

  // MARK: - Scanning
  func startScanning() {
    if let central = centralManager {
      central.scanForPeripherals(withServices: [ServiceUUID])
      //queue?.asyncAfter(deadline: .now() + 10.0) { self.stopScanning() }
    }
  }

  func stopScanning() {
    if let central = centralManager {
      postScanning(false)
      central.stopScan()
    }
  }

  // MARK: - CBCentralManagerDelegate
  func centralManager(_ central: CBCentralManager,
                      didDiscover new_peripheral: CBPeripheral,
                      advertisementData: [String : Any],
                      rssi RSSI: NSNumber) {
    if new_peripheral.name == nil || new_peripheral.name == "" { return }
    print("Found device: \(new_peripheral.name ?? "NIL") [\(new_peripheral.identifier)]")

    if peripheral == nil || peripheral?.state == CBPeripheralState.disconnected {
      peripheral = new_peripheral
      service = nil

      print("Attempting connection with \(peripheral?.name ?? "NIL")")

      central.connect(peripheral!, options: nil)
      postFound(peripheral!)
    }
  }

  func centralManager(_ central: CBCentralManager,
                      didConnect peripheral: CBPeripheral) {
    if peripheral == self.peripheral {
      self.service = BTService(peripheral)
      print("Connected to \(peripheral.name ?? "NIL")")
    }

    //postConnected(true)
    central.stopScan()
  }

  func centralManager(_ central: CBCentralManager,
                      didDisconnectPeripheral peripheral: CBPeripheral,
                      error: Error?) {

    // See if it was our peripheral that disconnected
    if peripheral == self.peripheral {
      self.service = nil
      self.peripheral = nil
    }

    //postConnected(false)
    self.startScanning()
  }

  // MARK: - Private
  func clearDevices() {
    self.service = nil
    self.peripheral = nil
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

  // MARK: - Post Notifications
  func postFound(_ peripheral: CBPeripheral) {
    let info = ["peripheral": peripheral ]
    NotificationCenter.default.post(name: BLEFound,
                                    object: self,
                                    userInfo: info)
  }

  func postScanning(_ scanning: Bool) {
    NotificationCenter.default.post(name: BLEScanning,
                                    object: self,
                                    userInfo: ["scanning": scanning])
  }

}

