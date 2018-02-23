//
//  Device.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import CoreBluetooth

class Device {
  var name: String!
  var address: String!
  var description: String!

  init(_ peripheral: CBPeripheral!) {
    name = peripheral.name
    address = peripheral.identifier.uuidString
    description = peripheral.identifier.description
  }
}

func ==(lhs: Device, rhs: Device) -> Bool {
  return lhs.name == rhs.name && lhs.address == rhs.address
}
