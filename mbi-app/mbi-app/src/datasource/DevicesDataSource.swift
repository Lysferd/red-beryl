//
//  DevicesDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class DevicesDataSource: NSObject {
  let devices: [Device]

  init(_ devices: [Device]) {
    self.devices = devices
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
    cell.address = device.address
    return cell
  }
}
