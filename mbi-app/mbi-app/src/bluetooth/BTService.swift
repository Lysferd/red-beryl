//
//  BTService.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/24.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation
import CoreBluetooth

// MARK: Service & Characteristic UUIDs
let ServiceUUID = CBUUID(string: "FFE0")
let CharacteristicUUID = CBUUID(string: "FFE1")
let BLEUpdate = NSNotification.Name("BLEUpdate")
let BLEUpdateCHK = NSNotification.Name("BLEUpdateCHK")
let BLEUpdateGETREQ = NSNotification.Name("BLEUpdateGETREQ")
let BLEUpdateBAT = NSNotification.Name("BLEUpdateBAT")
let BLEUpdateCLR = NSNotification.Name("BLEUpdateCLR")
let BLEUpdateWIP = NSNotification.Name("BLEUpdateWIP")
let BLEUpdateTMP = NSNotification.Name("BLEUpdateTMP")
let BLEUpdateCLK = NSNotification.Name("BLEUpdateCLK")

class BTService: NSObject, CBPeripheralDelegate {

  // MARK: - Properties
  let queue = NotificationCenter.default
  var peripheral: CBPeripheral?
  var characteristic: CBCharacteristic?
  var txTimer: Timer?
  var allowTX: Bool = true
  var command_queue: [String] = []
  var command: String = ""
  var partial: String = ""
  var reading: [String: String] = [:]

  // MARK: - Initialization
  init(_ peripheral: CBPeripheral) {
    super.init()
    self.peripheral = peripheral
    self.peripheral?.delegate = self
    startDiscoveringServices()
  }

  deinit { self.reset() }

  // MARK: - Connection
  func startDiscoveringServices() {
    self.peripheral?.discoverServices([ServiceUUID])
  }

  func reset() {
    if peripheral != nil { peripheral = nil }
  }

  // MARK: - Peripheral Delegate Functions
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    if peripheral != self.peripheral { return }
    if error != nil { return }
    if peripheral.services == nil || peripheral.services!.count == 0 { return }

    for service in peripheral.services! {
      if service.uuid == ServiceUUID {
        peripheral.discoverCharacteristics([CharacteristicUUID], for: service)
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if (peripheral != self.peripheral) { return }
    if (error != nil) { return }

    if let characteristics = service.characteristics {
      for characteristic in characteristics {
        if characteristic.uuid == CharacteristicUUID {
          self.characteristic = characteristic
          peripheral.setNotifyValue(true, for: characteristic)
          postConnected(true)
        }
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if peripheral != self.peripheral { return }
    if error != nil { return }
    if characteristic != self.characteristic { return }

    stopTimer()

    // Verify if message is chopped:
    if let data = characteristic.value {
      guard let input = String(bytes: data, encoding: .ascii) else { fatalError("Invalid message!") }
      print("Read from device: ", input, " [", data, "]")

      // Detect invalid requests:
      if input == "ERR" {
        command = ""
        //postError()
      }

      // Verify if message is chopped:
      partial.append(input)
      if partial.count < 3 { return }
      if partial.first != "S" || partial.last != "E" { return }

      // Unwrap message
      // Removes S from the beginning, E from the end
      var message = partial
      message.removeFirst()
      message.removeLast()

      // Send appropriated notification:
      switch command {
      case "CHK": postUpdateCHK(message)
      case "GET", "REQ":
        let tag = message.removeFirst()
        reading[String(tag)] = message
        if reading.count == 4 {
          print(reading)
          postUpdateGetReq(reading)
          reading.removeAll()
        }
      case "BAT": postUpdateBAT(message)
      case "CLR": postUpdateCLR(message)
      case "WIP": postUpdateWIP(message)
      case "TMP": postUpdateTMP(message)
      case "CLK": postUpdateCLK(message)
      default: postUpdate(characteristic)
      }

      partial = ""
      if command_queue.count > 0 {
        let next_command = command_queue.removeFirst()
        write(next_command)
      }
    }
  }

  // MARK: - Data TX & RX
  func write(_ string: String, arg: Int? = nil) {

    if !allowTX {
      command_queue.append(string)
      return
    }

    command = string
    var tx = string
    if arg != nil { tx.append(String(arg!)) }

    if let characteristic = self.characteristic {
      if let data = tx.data(using: .ascii) {
        print("Write to device: ", tx, " [", data, "]")
        self.peripheral?.writeValue(data, for: characteristic, type: .withoutResponse)
        startTimer()
      }
    }
  }

  func read() -> String {
    if let characteristic = self.characteristic {
      if let data = characteristic.value {
        if let input = String(bytes: data, encoding: .ascii) {
          print("Read from device: ", input, " [", data, "]")
          return input
        }
      }
    }
    return "<error>"
  }

  // MARK: - TX Timer
  func startTimer(_ delay: Double = 5.0) {
    allowTX = false
    txTimer = Timer.scheduledTimer(timeInterval: delay,
                                   target: self,
                                   selector: #selector(stopTimer),
                                   userInfo: nil, repeats: false)
  }

  @objc func stopTimer() {
    if txTimer == nil { return }
    txTimer?.invalidate()
    txTimer = nil
    allowTX = true
  }

  // MARK: - Notifications
  func postConnected(_ connected: Bool) {
    let info = ["connected": connected]
    queue.post(name: BLEConnected, object: self, userInfo: info)
  }

  func postUpdate(_ characteristic: CBCharacteristic) {
    let info = ["characteristic": characteristic]
    queue.post(name: BLEUpdate, object: self, userInfo: info)
  }

  func postUpdateCHK(_ data: String) {
    let info = ["data": data]
    queue.post(name: BLEUpdateCHK, object: self, userInfo: info)
  }

  func postUpdateGetReq(_ reading: [String: String]) {
    queue.post(name: BLEUpdateGETREQ, object: self, userInfo: reading)
  }

  func postUpdateBAT(_ data: String) {
    let info = ["battery": data]
    queue.post(name: BLEUpdateBAT, object: self, userInfo: info)
  }

  func postUpdateCLR(_ data: String) {
    //queue.post(name: BLEUpdateGETREQ, object: self, userInfo: reading)
  }

  func postUpdateWIP(_ data: String) {
    //queue.post(name: BLEUpdateGETREQ, object: self, userInfo: reading)
  }

  func postUpdateTMP(_ data: String) {
    let info = ["temperature": data]
    queue.post(name: BLEUpdateTMP, object: self, userInfo: info)
  }

  func postUpdateCLK(_ data: String) {
    //queue.post(name: BLEUpdateGETREQ, object: self, userInfo: reading)
  }
}
