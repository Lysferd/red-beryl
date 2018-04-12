//
//  SelectMeasureView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/15.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import CoreBluetooth

class SelectMeasureView: UIViewController {

  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var measuresTable: UITableView!
  @IBOutlet weak var batteryLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var progressBar: UIProgressView!

  @IBOutlet weak var batteryImage: UIImageView!
  @IBOutlet weak var tmpImage: UIImageView!

  // MARK: Properties
  public var selection: Int?
  let datasource: MeasuresDataSource
  var dataDate: String?
  var dataReal: Double?
  var dataImg: Double?
  var dataFreq: Double?

  // BLE Communication
  fileprivate var queue = DispatchQueue.main
  fileprivate var partialMessage: String!
  fileprivate var getIndex: Int = 0
  fileprivate var getMax: Int = 0

  required init?(coder aDecoder: NSCoder) {
    datasource = MeasuresDataSource()
    super.init(coder: aDecoder)
  }

  override func viewWillAppear(_ animated: Bool) {
    _ = btDiscoverySharedInstance
    btDiscoverySharedInstance.startScanning()
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

    batteryImage.image = batteryImage.image?.withRenderingMode(.alwaysTemplate)
    batteryImage.tintColor = UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1)

    tmpImage.image = tmpImage.image?.withRenderingMode(.alwaysTemplate)
    tmpImage.tintColor = UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1)

    super.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    datasource.clear()
    measuresTable.reloadData()

    // Do not disconnect in case something has been selected
    // so that the previous controller can send requests
    if selection == nil {
      btDiscoverySharedInstance.disconnect()
    }

    super.viewWillDisappear(animated)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if let index = measuresTable.indexPathForSelectedRow {
      selection = index.row
    }
  }

  private func refreshTable(_ data: Measure) {
    if datasource.append(data) {
      let index = IndexPath(row: datasource.count() - 1, section: 0)
      measuresTable.insertRows(at: [index], with: .right)
    }
  }

  private func refreshGetReqProgress() {
    if getIndex < getMax {
      getIndex += 1
      let progress = Float(getIndex) / Float(getMax)
      progressBar.setProgress(progress, animated: true)
    } else {
      getMax = 0
      getIndex = 0
      progressBar.setProgress(1.0, animated: true)
      infoLabel.text = "Concluído" // FIXME: translation needed
      refreshButton.isEnabled = true
      addButton.isEnabled = true
      doneButton.isEnabled = true
    }
  }

  @IBAction func addMeasure(_ sender: Any) {
    if let service = btDiscoverySharedInstance.service {
      service.write("REQ", with: 50000) // FIXME: Frequency MUST BE selectable
    }
  }

  // MARK: - Notifications
  @objc func connectionChanged(_ notification: Notification) {
    let userInfo = notification.userInfo as! [String: Bool]
    NSLog("Connection Changed")

    queue.async {
      if let connected = userInfo["connected"], connected == true {
        if let service = btDiscoverySharedInstance.service {
          service.write("BAT")
          service.write("TMP")
          service.write("CHK")
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
          for i in 1...self.getMax {
            service.write("GET", with: i)
          }
        }

      }
    }
  }

  @objc func updateGETREQ(_ notification: Notification) {
    let info = notification.userInfo as! [String: RawGETData]

    queue.async {
      if let measure = info["measure"] {
        let date = measure.date
        let frequency = measure.frequency
        let impedance = measure.impedance

        let measure = Measure(date: date, frequency: frequency, impedance: impedance)
        self.refreshTable(measure)
        self.refreshGetReqProgress()
      }
    }
  }

  @objc func updateBAT(_ notification: Notification) {
    let info = notification.userInfo as! [String: String]

    queue.async {
      if let battery = info["battery"] {
        if let b = Int(battery) {
          if b < 10 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_10_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 20 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_20_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 30 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_30_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 40 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_40_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 50 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_50_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 60 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_60_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 70 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_70_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 80 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_80_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 90 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_90_36pt").withRenderingMode(.alwaysTemplate)
          } else if b < 100 {
            self.batteryImage.image = #imageLiteral(resourceName: "ic_battery_full_36pt").withRenderingMode(.alwaysTemplate)
          }
        }

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
