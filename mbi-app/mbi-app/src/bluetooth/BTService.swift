//
//  BTService.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/24.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation
import CoreBluetooth

/* Services & Characteristics UUIDs */
let BLEServiceUUID = CBUUID(string: "FFE0") //"025A7775-49AA-42BD-BBDB-E2AE77782966")
let CharacteristicUUID = CBUUID(string: "FFE1") //"F38A2C23-BC54-40FC-BED0-60EDDA139F47")
let BLEServiceChangedStatusNotification = NSNotification.Name(rawValue: "kBLEServiceChangedStatusNotification")
let BLEServiceDiscoveringNotification = NSNotification.Name(rawValue: "kBLEServiceDiscoveringNotification")

class BTService: NSObject, CBPeripheralDelegate {
  var peripheral: CBPeripheral?
  var dataCharacteristic: CBCharacteristic?

  init(initWithPeripheral peripheral: CBPeripheral) {
    super.init()

    self.peripheral = peripheral
    self.peripheral?.delegate = self
  }

  deinit {
    self.reset()
  }

  func startDiscoveringServices() {
    self.peripheral?.discoverServices([BLEServiceUUID])
  }

  func reset() {
    if peripheral != nil {
      peripheral = nil
    }

    // Deallocating therefore send notification
    self.sendBTServiceNotificationWithIsBluetoothConnected(false)
  }

  // Mark: - CBPeripheralDelegate

  ////////////////////////////////////////////////////////////////////////////
  //
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    let uuidsForBTService: [CBUUID] = [CharacteristicUUID]

    /*
     if (peripheral != self.peripheral) {
     // Wrong Peripheral
     return
     }

     if (error != nil) {
     return
     }

     if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
     // No Services
     return
     }
     */

    for service in peripheral.services! {
      NSLog("Found service: %@", service.description)

      if service.uuid == BLEServiceUUID {
        peripheral.discoverCharacteristics(uuidsForBTService, for: service)
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  //
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    /*
     if (peripheral != self.peripheral) {
     // Wrong Peripheral
     return
     }

     if (error != nil) {
     return
     }
     */

    if let characteristics = service.characteristics {
      for characteristic in characteristics {
        print("Found characteristic: ", characteristic.description, "(", characteristic.properties, ")")

        if characteristic.uuid == CharacteristicUUID {
          self.dataCharacteristic = (characteristic)
          peripheral.setNotifyValue(true, for: characteristic)

          // Send notification that Bluetooth is connected and all required characteristics are discovered
          self.sendBTServiceNotificationWithIsBluetoothConnected(true)
        }
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  //
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if (peripheral != self.peripheral) {
      return
    }

    if (error != nil) {
      return
    }

    if (characteristic != self.dataCharacteristic) {
      return
    }

    print("CHECKING FOR CHANGED CHARACTERISTICS")
    print(characteristic)
  }

  ////////////////////////////////////////////////////////////////////////////
  //
  func write(_ string: String) {
    if let characteristic = self.dataCharacteristic {
      if let tx = string.data(using: .ascii) {
        print("Write to device: ", string, " [", tx, "]")
        self.peripheral?.writeValue(tx, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  // Read Input from Remote
  func read() -> String {
    if let characteristic = self.dataCharacteristic {
      if let rx = characteristic.value {
        if let input = String(bytes: rx, encoding: String.Encoding.ascii) {
          print("Read from device: ", input, " [", rx, "]")
          return input
        }
      }
    }
    return "<nil>"
  }

  ////////////////////////////////////////////////////////////////////////////
  // Read Board Clock
  func getBoardClock() -> String {
    self.write("AT")
    return self.read()
    //return "nil"
  }

  // MARK: Notifications
  func sendBTServiceNotificationWithIsBluetoothConnected(_ isBluetoothConnected: Bool) {
    let connectionDetails = ["isConnected": isBluetoothConnected]
    NotificationCenter.default.post(name: BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
  }

  func sendBTServiceNotificationWithIsDiscovering(_ isDiscovering: Bool) {
    let details = ["isDiscovering": isDiscovering]
    NotificationCenter.default.post(name: BLEServiceDiscoveringNotification, object: self, userInfo: details)
  }

}
