//
//  DeviceCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {

  // MARK: Properties
  @IBOutlet weak var deviceName: UILabel!
  @IBOutlet weak var deviceAddress: UILabel!

  var name: String? {
    didSet { deviceName.text = name }
  }

  var address: String? {
    didSet { deviceAddress.text = address }
  }

}
