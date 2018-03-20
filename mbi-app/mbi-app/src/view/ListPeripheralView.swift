//
//  ListPeripheralView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/24.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import CoreBluetooth

class ListPeripheralView: UIViewController {

  // MARK: GUI Outlets
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var devicesTable: UITableView!

  // MARK: Instance Objects
  //fileprivate var bluetooth = BTDiscovery()
  fileprivate var queue: DispatchQueue!
  fileprivate let datasource: DevicesDataSource

  required init?(coder aDecoder: NSCoder) {
    datasource = DevicesDataSource()
    queue = DispatchQueue.main
    
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    devicesTable.dataSource = datasource
    devicesTable.reloadData()

    // Start the notification observers
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(getPeripheralFound(_:)),
                   name: BLEFound,
                   object: nil)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(getScanning(_:)),
                   name: BLEScanning,
                   object: nil)

    // Start the Bluetooth discovery process
    //_ = btDiscoverySharedInstance
  }

  // MARK: - Actions
  @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem) {
    //bluetooth.startScanning()
  }
  
  // MARK: - Notifications
  @objc func getPeripheralFound(_ notification: Notification) {
    let info = notification.userInfo as! [String: CBPeripheral]
    guard let peripheral = info["peripheral"] else { return }

    queue.async {
      if self.datasource.append(Device(peripheral)) {
        self.devicesTable.reloadData()
      }
    }
  }

  @objc func getScanning(_ notification: Notification) {
    let info = notification.userInfo as! [String: Bool]
    guard let scanning = info["scanning"] else { return }
    
    queue.async {
      //self.navigationItem.setLeftBarButtonItems(nil, animated: false)

      if scanning {
        //self.navigationItem.setLeftBarButtonItems([self.refreshButton], animated: true)
      } else {
        //self.navigationItem.setLeftBarButtonItems([self.refreshSpinner], animated: true)
      }
    }
  }

}
