//
//  ExamListView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/24.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ExamListView: UIViewController {

  // MARK: GUI Outlets
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var devicesTable: UITableView!

  // MARK: Instance Objects
  var bluetooth: BTDiscovery?
  let datasource: DevicesDataSource

  required init?(coder aDecoder: NSCoder) {
    let devices = [ Device(name: "BT_Device", address: "01:AB:U4:C6:A2") ]
    datasource = DevicesDataSource(devices)
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    devicesTable.dataSource = datasource
    devicesTable.reloadData()

    // Start the Bluetooth discovery process
    _ = btDiscoverySharedInstance
  }
}
