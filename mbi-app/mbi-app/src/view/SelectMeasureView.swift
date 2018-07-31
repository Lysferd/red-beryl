//
//  SelectMeasureView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/15.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

/*
BLE COMMANDS

 VER
  Retrieves board firmware version

 CHK
  Retrieves number of measured data

 GET[n]
  Retrieves simplified measure data

 REQ[f]
  Requests new measure and retrieves it

 GTX[n]
  Retrieves complete measure data

 CLR[n]
  Clears specific measure data (purge data pointer)

 WIP
  Wipes board measure data (overwrite with zeroes)

 TMP
  Retrieves board temperature

 CLK
  Retrieves board clock

 BAT
  Retrieves board battery
*/

import UIKit
import CoreBluetooth

class SelectMeasureView: UIViewController {

  typealias RawData = (date: String, frequency: Double, impedance: (Double, Double))

  // MARK: Outlets
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var measuresTable: UITableView!
  @IBOutlet weak var batteryLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var batteryImage: UIImageView!
  @IBOutlet weak var tmpImage: UIImageView!

  // MARK: Properties
  public var selection: IndexPath?
  let datasource: MeasuresDataSource
  var dataDate: String?
  var dataReal: Double?
  var dataImg: Double?
  var dataFreq: Double?

  var sweeping = false

  // MARK: BLE Communication
  fileprivate var queue = DispatchQueue.main
  fileprivate var partialMessage: String!
  fileprivate var getIndex: Int = 0
  fileprivate var getMax: Int = 0

  // MARK: - Functions
  // Constructor
  required init?(coder aDecoder: NSCoder) {
    datasource = MeasuresDataSource()
    super.init(coder: aDecoder)
  }

  // AtLoad
  override func viewWillAppear(_ animated: Bool) {
    // Setup observers //
    observer(for: BLEUpdateCHK, function: #selector(updateCHK(_:)))
    observer(for: BLEUpdateGETREQ, function: #selector(updateGETREQ(_:)))
    observer(for: BLEUpdateBAT, function: #selector(updateBAT(_:)))
    observer(for: BLEUpdateCLR, function: #selector(updateCLR(_:)))
    observer(for: BLEUpdateTMP, function: #selector(updateTMP(_:)))
  }

  override func viewDidLoad() {
    // Setup table //
    measuresTable.tableFooterView = UIView()
    measuresTable.dataSource = datasource
    measuresTable.delegate = datasource
    measuresTable.reloadData()

    // Setup images //
    batteryImage.image = batteryImage.image?.withRenderingMode(.alwaysTemplate)
    batteryImage.tintColor = UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1)
    tmpImage.image = tmpImage.image?.withRenderingMode(.alwaysTemplate)
    tmpImage.tintColor = UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1)

    // Check if selection exists //
    if let selection = self.selection {
      datasource.selectedMeasure = selection
    }

    if let service = btDiscoverySharedInstance.service {
      service.write("BAT")
      service.write("TMP")
      service.write("CHK")
    }

    super.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    // Release observers //
    releaseObservers()

    performSegue(withIdentifier: "back", sender: self)

    datasource.clear()
    measuresTable.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let index = datasource.selectedMeasure {
      selection = index
    }
  }

  private func refreshTable(_ data: Measure) {
    if datasource.append(data) {
      let index = IndexPath(row: datasource.count - 1, section: 0)
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
    }
  }

  @IBAction func addMeasure(_ sender: Any) {
    let title = "Nova medição"
    let message = "Defina a frequência da medição no intervalo entre 10kHz e 100kHz:"

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = "Frequência (Hz)"
      textField.keyboardType = .numberPad
    }

    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Continuar", style: .default) {
      (_) in
      if let textFields = alert.textFields {
        if let frequency = textFields[0].text, let num = Int(frequency) {
          if num >= 5_000 && num <= 100_000 {
            self.sendREQ(num)
          }
        }
      }
    })

    self.present(alert, animated: true, completion: nil)
  }

  func sendREQ(_ frequency: Int) {
    if let service = btDiscoverySharedInstance.service {
      service.write("REQ", with: frequency)
    }
  }

  @IBAction func clean(_ sender: UIBarButtonItem) {
    if let service = btDiscoverySharedInstance.service {
      service.write("CLR")
    }
  }

  @IBAction func sweep(_ sender: UIBarButtonItem) {
    guard !sweeping else { return }
    sweeping = true

    if let service = btDiscoverySharedInstance.service {
      for frequency in stride(from: 1e3, through: 1e5, by: 1e3) {
        service.write("REQ", with: Int(frequency))
      }
    }
  }


  // MARK: - Notifications
  @objc func updateCHK(_ notification: Notification) {
    let info = notification.userInfo as! [String: String]

    queue.async {
      if let data = info["data"] {
        guard let number = Int(data), number > 0 else {
          self.refreshButton.isEnabled = true
          self.addButton.isEnabled = true
          self.infoLabel.text = "Não há medições realizadas"
          return
        }

        self.infoLabel.text = "Sincronizando \(data) medições..." // FIXME: translation needed
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
    let info = notification.userInfo as! [String: RawData]

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

  @objc func updateTMP(_ notification: Notification) {
    let info = notification.userInfo as! [String: String]

    queue.async {
      if let temperature = info["temperature"] {
        self.temperatureLabel.text = temperature + "°C"
      }
    }
  }

//  @objc func updateCLK(_ notification: Notification) {
//    return
//  }

}
