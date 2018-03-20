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

class BTService: NSObject {

  // FIXME: use proper struct
  typealias RawMeasure = (date: String?, frequency: Double?, rValues: [Double], jValues: [Double])

  // MARK: - Properties
  // Bluetooth properties
  let notification = NotificationCenter.default // aliasing
  var peripheral: CBPeripheral?                 // peripheral instance
  var characteristic: CBCharacteristic?         // peripheral's characteristic

  // Timing handling to avoid message spam
  var txTimer: Timer?       // timer to avoid transmission spam
  var allowTX: Bool = true  // blocks transmission during timeout

  // Message system workaround for single-characteristic module
  var command: String = ""                 // last command transmitted
  var command_queue: [String] = []         // next command to transmit
  var partial: String = ""                 // partial message received
  var measure: RawMeasure = (date: nil, frequency: nil, rValues: [], jValues: [])
  var m_index: Int = 0

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

  // FIXME: deprecated: reading is now handled by CBCentralManager
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
  func startTimer(_ delay: Double = 2.0) {
    allowTX = false
    txTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(stopTimer), userInfo: nil, repeats: false)
  }

  @objc func stopTimer() {
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

  func postUpdateGetReq(_ measure: RawMeasure) {
    let info = ["measure": measure]
    notification.post(name: BLEUpdateGETREQ, object: self, userInfo: info)
  }

  func postUpdateBAT(_ data: String) {
    let info = ["battery": data]
    notification.post(name: BLEUpdateBAT, object: self, userInfo: info)
  }

  func postUpdateCLR(_ data: String) {
    //notification.post(name: BLEUpdateGETREQ, object: self, userInfo: reading)
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
      print(message)
      message.removeFirst()
      message.removeLast()

      // Send appropriated notification:
      switch command {
      case "CHK": postUpdateCHK(message)
      case "GET", "REQ":
        // GET/REQ message has the following pattern:
        //
        // D17/03/18 19:34
        // F50000
        // R11831.64J-16612.82
        // R11063.00J-17163.00
        // R11223.00J-17051.00
        // R11386.00J-16941.00
        // R11527.00J-16842.00
        // R11699.00J-16720.00
        // R11844.00J-16612.00
        // R11998.00J-16504.00
        // R12151.00J-16388.00
        // R12295.00J-16275.00
        // R12440.00J-16163.00
        // R12522.00J-16082.00
        // R-17163.00J0.00
        var data = message.split(separator: "|")
        for i in 0..<data.count {
          let tag = data[i].removeFirst()
          switch tag {
          case "D":
            measure.date = String(data[i])
          case "F":
            if let frequency = Double(data[i]) { measure.frequency = frequency }
          case "R":
            let impedance = data[i].split(separator: "J")
            if let real = Double(impedance[0]), let img = Double(impedance[1]) {
              measure.rValues.append(real)
              measure.jValues.append(img)
            }
          default:
            // WILD TAG APPEARS
            print("TAG [" + String(tag) + "]\t PARTIAL [" + partial + "]")
          }
        }
        if measure.date == nil {
          print("NIL DATE")
          measure.date = "09/09/09 19:19"

        }
        if measure.frequency == nil {
          print("NIL FREQUENCY")
          measure.frequency = 50e3
        }
        if measure.rValues.isEmpty {
          print("NIL R VALUES")
          measure.rValues = [11065.0, 11227.0, 11382.0, 11549.0, 11689.0, 11852.0, 12000.0, 12148.0, 12296.0, 12449.0, 12520.0]
        }
        if measure.jValues.isEmpty {
          print("NIL J VALUES")
          measure.jValues = [-17162.0, -17050.0, -16934.0, -16828.0, -16728.0, -16608.0, -16503.0, -16387.0, -16273.0, -16155.0, -16079.0]
        }
        print(measure)
        postUpdateGetReq(measure)
        measure = (date: nil, frequency: nil, rValues: [], jValues: [])
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

}
