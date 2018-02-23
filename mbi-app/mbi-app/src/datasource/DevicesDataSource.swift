//
//  DevicesDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class DevicesDataSource: NSObject {
  var devices: [Device]!

  init(devices: [Device] = []) {
    self.devices = devices
  }

  func append(_ device: Device) -> Bool {
    if devices.contains(where: { $0 == device }) { return false }
    devices.append(device)
    return true
  }
}

extension DevicesDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return devices.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeviceCell.self)) as! DeviceCell
    let device = devices[indexPath.row]
    
    cell.name = device.name
    return cell
  }
}
