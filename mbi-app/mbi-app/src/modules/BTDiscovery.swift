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

class BTDiscovery: NSObject {

  // MARK: - Private Variables
  var queue: DispatchQueue!
  var centralManager: CBCentralManager!
  fileprivate var peripheral: CBPeripheral?
  fileprivate let notification = NotificationCenter.default

  var service: BTService?

  // MARK: - Initialization
  override init() {
    super.init()

    queue = DispatchQueue(label: "eng.moritzalmeida")
    centralManager = CBCentralManager(delegate: self, queue: queue)
  }

  // MARK: - Scanning
  func startScanning() {
    if centralManager.isScanning { return }
    centralManager.scanForPeripherals(withServices: [ServiceUUID])
  }

  func stopScanning() {
    postScanning(false)
    centralManager.stopScan()
  }

  func disconnect() {
    if let peripheral = self.peripheral {
      centralManager.cancelPeripheralConnection(peripheral)
      clearDevices()
    }
  }

  func clearDevices() {
    self.service = nil
    self.peripheral = nil
  }

}

extension BTDiscovery: CBCentralManagerDelegate {

  // MARK: - CBCentralManagerDelegate
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

    if peripheral.name == nil || peripheral.name == "" { return }
    print("Found device: \(peripheral.name ?? "NIL") [\(peripheral.identifier)]")

    if self.peripheral == nil || self.peripheral?.state == .disconnected {
      self.peripheral = peripheral
      service = nil

      print("Attempting connection with \(self.peripheral?.name ?? "NIL")")

      central.connect(peripheral, options: nil)
      postFound(peripheral)
    }
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    if self.peripheral != peripheral { return }
    self.service = BTService(peripheral)
    print("Connected to \(peripheral.name ?? "NIL")")

    central.stopScan()
    //postConnected(true)
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    if error != nil { return }

    print("[DISCONNECTED TO MBI]")

    // See if it was our peripheral that disconnected
    if self.peripheral == peripheral { clearDevices() }
    postConnected(false)
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
  func postConnected(_ status: Bool) {
    let info = ["connected": status]
    notification.post(name: BLEConnected, object: self, userInfo: info)
  }

  func postFound(_ peripheral: CBPeripheral) {
    let info = ["peripheral": peripheral ]
    notification.post(name: BLEFound, object: self, userInfo: info)
  }

  func postScanning(_ scanning: Bool) {
    let info = ["scanning": scanning]
    notification.post(name: BLEScanning, object: self, userInfo: info)
  }

}

