//
//  MeasureListView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/15.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import CoreBluetooth

class MeasureListView: UIViewController {

  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var measuresTable: UITableView!
  @IBOutlet weak var batteryLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var progressBar: UIProgressView!

  // MARK: Properties
  let datasource: MeasuresDataSource
  var dataDate: String?
  var dataReal: Double?
  var dataImg: Double?
  var dataFreq: Double?

  // BLE Communication
//  fileprivate var btDiscovery: BTDiscovery?
  fileprivate var queue = DispatchQueue.main
  fileprivate var partialMessage: String!
  fileprivate var getIndex: Int = 0
  fileprivate var getMax: Int = 0

  required init?(coder aDecoder: NSCoder) {
    datasource = MeasuresDataSource()

    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    NotificationCenter.default.addObserver(self, selector: #selector(connectionChanged(_:)), name: BLEConnected, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateCharacteristic(_:)), name: BLEUpdate, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateCHK(_:)), name: BLEUpdateCHK, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateGETREQ(_:)), name: BLEUpdateGETREQ, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateBAT(_:)), name: BLEUpdateBAT, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateCLR(_:)), name: BLEUpdateCLR, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateWIP(_:)), name: BLEUpdateWIP, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateTMP(_:)), name: BLEUpdateTMP, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateCLK(_:)), name: BLEUpdateCLK, object: nil)

    measuresTable.tableFooterView = UIView()
    measuresTable.dataSource = datasource
    measuresTable.reloadData()
    _ = btDiscoverySharedInstance

    super.viewDidLoad()

    print("ENTERED SCREEN")
  }

  override func viewWillDisappear(_ animated: Bool) {

    super.viewWillDisappear(animated)
    print("LEAVING SCREEN")
  }

  override func viewDidDisappear(_ animated: Bool) {
    btDiscoverySharedInstance.disconnect()
    super.viewDidDisappear(animated)

    print("LEFT SCREEN")
  }

  private func refreshTable(_ data: Measure) {
    if datasource.append(data) {
      let index = IndexPath(row: datasource.count() - 1, section: 0)
      measuresTable.insertRows(at: [index], with: .right)
    }
  }

  private func refreshGetReqProgress() {
    if getIndex < getMax {
        if let service = btDiscoverySharedInstance.service {
          getIndex += 1
          let progress = Float(getIndex) / Float(getMax)
          progressBar.setProgress(progress, animated: true)
          service.write("GET", arg: getIndex)
      }
    } else {
      getMax = 0
      getIndex = 0
      progressBar.setProgress(1.0, animated: true)
      spinner.stopAnimating()
      infoLabel.text = "Sincronização concluída." // FIXME: translation needed
    }
  }

  @IBAction func addMeasure(_ sender: Any) {

      if let service = btDiscoverySharedInstance.service {
        service.write("REQ", arg: 50000)
      }

  }

  // MARK: - Notifications
  @objc func connectionChanged(_ notification: Notification) {
    let userInfo = notification.userInfo as! [String: Bool]
    NSLog("Connection Changed")

    queue.async {
      if let connected = userInfo["connected"] {
        if connected {

            if let service = btDiscoverySharedInstance.service {
              service.write("BAT")
              service.write("TMP")
              service.write("CHK")

          }
        } else {
          // do something if connection fails:
          // "no mbi devices were found"
        }
      }
    }
  }

  @objc func updateCharacteristic(_ notification: Notification) {
    //_ = notification.userInfo as! [String: CBCharacteristic]
    return
  }

  @objc func updateCHK(_ notification: Notification) {
    let info = notification.userInfo as! [String: String]

    queue.async {
      if let data = info["data"] {
        self.infoLabel.text = "Sincronizando \(data) medições..." // FIXME: translation needed
        guard let number = Int(data), number > 0 else { return }

        self.getMax = number
        self.getIndex = 1
        self.progressBar.setProgress(1.0 / Float(number), animated: true)

          if let service = btDiscoverySharedInstance.service {
            service.write("GET", arg: self.getIndex)
          }

      }
    }
  }

  @objc func updateGETREQ(_ notification: Notification) {
    let info = notification.userInfo as! [String: String]

    queue.async {
      guard let date = info["D"] else { return }
      guard let real = Double(info["R"]!) else { return }
      guard let imaginary = Double(info["J"]!) else { return }
      guard let frequency = Double(info["F"]!) else { return }
      let measure = Measure(real: real, imaginary: imaginary, frequency: frequency, date: date)

      self.refreshTable(measure)
      self.refreshGetReqProgress()
    }
  }

  @objc func updateBAT(_ notification: Notification) {
    let info = notification.userInfo as! [String: String]

    queue.async {
      if let battery = info["battery"] {
        self.batteryLabel.text = battery + "%"
      }
    }
  }

  @objc func updateCLR(_ notification: Notification) {
    return
  }

  @objc func updateWIP(_ notification: Notification) {
    return
  }

  @objc func updateTMP(_ notification: Notification) {
    let info = notification.userInfo as! [String: String]

    queue.async {
      if let temperature = info["temperature"] {
        self.temperatureLabel.text = temperature + "ºC"
      }
    }
  }

  @objc func updateCLK(_ notification: Notification) {
    return
  }

}
