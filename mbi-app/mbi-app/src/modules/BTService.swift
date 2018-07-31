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
let BLEUpdateGTX = NSNotification.Name("BLEUpdateGTX")
let BLEUpdateBAT = NSNotification.Name("BLEUpdateBAT")
let BLEUpdateCLR = NSNotification.Name("BLEUpdateCLR")
let BLEUpdateWIP = NSNotification.Name("BLEUpdateWIP")
let BLEUpdateTMP = NSNotification.Name("BLEUpdateTMP")
let BLEUpdateCLK = NSNotification.Name("BLEUpdateCLK")

class BTService: NSObject {

  typealias RawData = (date: String, frequency: Double, impedance: (Double, Double))

  // MARK: - Properties
  // Bluetooth properties
  let notification = NotificationCenter.default // aliasing
  var peripheral: CBPeripheral?                 // peripheral instance
  var characteristic: CBCharacteristic?         // peripheral's characteristic

  // Timing handling to avoid message spam
  var txTimer: Timer?       // timer to avoid transmission spam
  var rxTimer: Timer?       // timeout for data RX
  var allowTX: Bool = true  // blocks transmission during timeout

  // Message system workaround for single-characteristic module
  var command: (String, Int?)?              // last command transmitted
  var command_queue: [(String, Int?)] = [] // next command to transmit
  var partial: String = ""                 // partial message received


  // MARK: - Constructors
  init(_ peripheral: CBPeripheral) {
    super.init()
    self.peripheral = peripheral
    self.peripheral?.delegate = self
    startDiscoveringServices()
  }

  // Force reset at deconstruction
  deinit { self.reset() }

  // MARK: - Connection
  func startDiscoveringServices() {
    self.peripheral?.discoverServices([ServiceUUID])
  }

  func reset() {
    if peripheral != nil { peripheral = nil }
  }

  // MARK: - Data TX & RX
  func write(_ string: String, with arg: Int? = nil) {

    guard allowTX else {
      command_queue.append((string, arg))
      return
    }

    command = (string, arg)
    var tx = string
    if arg != nil { tx.append(String(arg!)) }

    if let characteristic = self.characteristic {
      if let data = tx.data(using: .ascii) {
//        print("Write to device: ", tx, " [", data, "]")
        self.peripheral?.writeValue(data, for: characteristic, type: .withoutResponse)
        startTimer()
      }
    }
  }

  // Resend command
  @objc func rewrite() {
    stopTimer()

//    if let (cmd, arg) = command {
//      write(cmd, with: arg)
//    }
  }

  @available(*, deprecated: 1.0, message: "BLE data reading is now handled by CBCentralManager")
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

  // MARK: - Timers
  func startTimer(_ delay: Double = 2.0) {
    allowTX = false
    txTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(rewrite), userInfo: nil, repeats: false)
  }

  func stopTimer() {
    if txTimer == nil { return } // nothing to stop
    txTimer?.invalidate()
    txTimer = nil
    allowTX = true
  }

  // MARK: - Notifications
  func postConnected(_ status: Bool) {
    let info = ["connected": status]
    notification.post(name: BLEConnected, object: self, userInfo: info)
  }

  func postUpdate(_ characteristic: CBCharacteristic) {
    let info = ["characteristic": characteristic]
    notification.post(name: BLEUpdate, object: self, userInfo: info)
  }

  func postUpdateCHK(_ data: String) {
    let info = ["data": data]
    notification.post(name: BLEUpdateCHK, object: self, userInfo: info)
  }

  func postUpdateGetReq(_ data: String) {
    var measure: RawData = (date: "", frequency: 0.0, impedance: (0.0, 0.0))

    var data_array = data.split(separator: "|")
    for i in 0..<data_array.count {
      let tag = data_array[i].removeFirst()
      switch tag {
      case "D":
        measure.date = String(data_array[i])
      case "F":
        measure.frequency = Double(data_array[i])!
      case "R":
        let impedance = data_array[i].split(separator: "J")
        if let real = Double(impedance[0]), let img = Double(impedance[1]) {
          measure.impedance = (real, img)
        }
      default: print("TAG [" + String(tag) + "]\nPARTIAL [" + data + "]")
      }
    }

    print(measure)

    let info = ["measure": measure]
    notification.post(name: BLEUpdateGETREQ, object: self, userInfo: info)
  }

  func postUpdateGTX(_ data: String) {
    var measure: RawGTXData = (date: "", frequency: 0.0, impedances: [])

    var data_array = data.split(separator: "|")
    for i in 0..<data_array.count {
      let tag = data_array[i].removeFirst()
      switch tag {
      case "D":
        measure.date = String(data_array[i])
      case "F":
        if let frequency = Double(data_array[i]) { measure.frequency = frequency }
      case "R":
        let impedance = data_array[i].split(separator: ":")
        if let real = Double(impedance[0]), let img = Double(impedance[1]) {
          measure.impedances.append((real: real, imaginary: img))
        }
      default: print("TAG [" + String(tag) + "]\nPARTIAL [" + data + "]")
      }
    }

//    print(measure)

    let info = ["measure": measure]
    notification.post(name: BLEUpdateGTX, object: self, userInfo: info)
  }

  func postUpdateBAT(_ data: String) {
    let info = ["battery": data]
    notification.post(name: BLEUpdateBAT, object: self, userInfo: info)
  }

  func postUpdateCLR(_ data: String) {
    let info = ["clear": data]
    notification.post(name: BLEUpdateCLR, object: self, userInfo: info)
  }

  func postUpdateWIP(_ data: String) {
    //notification.post(name: BLEUpdateGETREQ, object: self, userInfo: reading)
  }

  func postUpdateTMP(_ data: String) {
    let info = ["temperature": data]
    notification.post(name: BLEUpdateTMP, object: self, userInfo: info)
  }

  func postUpdateCLK(_ data: String) {
    //notification.post(name: BLEUpdateCLK, object: self, userInfo: reading)
  }
}

extension BTService: CBPeripheralDelegate {

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

  //
  // didUpdateValueFor
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if peripheral != self.peripheral { return }
    if error != nil { return }
    if characteristic != self.characteristic { return }

    stopTimer()

    // Verify if message is chopped:
    if let data = characteristic.value {
      guard let input = String(bytes: data, encoding: .ascii) else {
        fatalError("Invalid message received from MBI device")

      }
//      print("Read from device: ", input, " [", data, "]")

      // Detect invalid requests:
      if input == "ERR" { command = nil }

      // Verify if message is chopped:
      partial.append(input)
      if partial.count < 3 { return }
      if partial.first != "S" || partial.last != "E" { return }

      // Unwrap message
      // Removes S from the beginning, E from the end
      var message = partial
//      print(message)
      message.removeFirst()
      message.removeLast()

      // Send appropriated notification:
      if let (cmd, _) = command {
        switch cmd {
        case "CHK": postUpdateCHK(message)
        case "GTX": postUpdateGTX(message)
        case "GET", "REQ": postUpdateGetReq(message)
        case "BAT": postUpdateBAT(message)
        case "CLR": postUpdateCLR(message)
        case "WIP": postUpdateWIP(message)
        case "TMP": postUpdateTMP(message)
        case "CLK": postUpdateCLK(message)
        default: postUpdate(characteristic)
        }
      }

      partial.removeAll()
      if command_queue.count > 0 {
        let (cmd, arg) = command_queue.removeFirst()
        write(cmd, with: arg)
      }
    }
  }

}
