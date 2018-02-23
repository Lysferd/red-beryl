//
//  DebugView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/12.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//
import UIKit
import CoreBluetooth

class DebugView: UIViewController {

  @IBOutlet weak var statusImg: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var uuidLabel: UILabel!
  @IBOutlet weak var serviceLabel: UILabel!
  @IBOutlet weak var characteristicLabel: UILabel!

  @IBOutlet weak var chkButton: UIBarButtonItem!
  @IBOutlet weak var batButton: UIBarButtonItem!
  @IBOutlet weak var getNumber: UITextField!
  @IBOutlet weak var getButton: UIButton!
  @IBOutlet weak var tmpButton: UIBarButtonItem!
  @IBOutlet weak var clrButton: UIBarButtonItem!
  @IBOutlet weak var wipButton: UIBarButtonItem!
  @IBOutlet weak var reqButton: UIBarButtonItem!

  @IBOutlet weak var clkField: UITextField!
  @IBOutlet weak var clkButton: UIButton!

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var realLabel: UILabel!
  @IBOutlet weak var imaginaryLabel: UILabel!
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var readingsLabel: UILabel!

  fileprivate var partialMessage: String!
  var timerTXDelay: Timer?
  var lastCommand: String!
  var allowTX = true

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    partialMessage = ""
    disconnect()

    // Watch Bluetooth connection
    //NotificationCenter.default.addObserver(self, selector: #selector(connectionChanged(_:)), name: BLEConnected, object: nil)

    //NotificationCenter.default.addObserver(self, selector: #selector(updateCharacteristic(_:)), name: BLEUpdate, object: nil)

    // Start the Bluetooth discovery process
    _ = btDiscoverySharedInstance
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.stopTimerTXDelay()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, with: event)
  }

  @objc func updateCharacteristic(_ notification: Notification) {
    let info = notification.userInfo as! [String: CBCharacteristic]

    DispatchQueue.main.async {
      if let characteristic: CBCharacteristic = info["characteristic"] {
        if let rx = characteristic.value {
          guard let input = String(bytes: rx, encoding: String.Encoding.ascii), input.count > 0 else { fatalError("invalid message") }
          print("Read from device: ", input, " [", rx, "]")

        }
      }
    }
  }

  @objc func connectionChanged(_ notification: Notification) {
    print( "Here" )
    // Connection status changed. Indicate on GUI.
    let userInfo = (notification as NSNotification).userInfo as! [String: Bool]

    DispatchQueue.main.async {
      // Set image based on connection status
      if let connected: Bool = userInfo["connected"] {
        if connected {
          self.connect()
        } else {
          self.disconnect()
        }
      }
    }
  }

  @IBAction func getClicked(_ sender: Any) {
    var i = "1"
    if !(getNumber.text?.isEmpty)! {
      i = getNumber.text!
    }

    sendMessage("GET\(i)")
    lastCommand = "GET"
  }

  @IBAction func clkClicked(_ sender: Any) {
    sendMessage("CLK")
    lastCommand = "CLK"

    return
    if (clkField.text?.isEmpty)! {
      sendMessage("CLK")
    } else {
      let i = clkField.text!
      sendMessage("CLK\(i)")
    }
  }

  @IBAction func batClicked(_ sender: Any) {
    sendMessage("BAT")
    lastCommand = "BAT"
  }

  @IBAction func tmpClicked(_ sender: Any) {
    sendMessage("TMP")
    lastCommand = "TMP"
  }

  @IBAction func chkClicked(_ sender: Any) {
    sendMessage("CHK")
    lastCommand = "CHK"
  }

  @IBAction func clrClicked(_ sender: Any) {
    sendMessage("CLR")
    lastCommand = "CLR"
  }

  @IBAction func wipClicked(_ sender: Any) {
    sendMessage("WIP")
    lastCommand = "WIP"
  }

  @IBAction func reqClicked(_ sender: Any) {
    sendMessage("REQ75840")
    lastCommand = "REQ"
  }

  private func redoMessage() {
    stopTimerTXDelay()
    sendMessage(lastCommand)
  }

  func getMessage() -> String {
    if let bleService = btDiscoverySharedInstance.service {
      return bleService.read()
    }
    return "[disconnected]"
  }

  func sendMessage(_ data: String) {
    if allowTX {
      if let bleService = btDiscoverySharedInstance.service {
        bleService.write( data )
        startTimerTXDelay()
      }
    }
  }

  @objc func timerTXDelayElapsed() {
    allowTX = true
    stopTimerTXDelay()
  }

  func startTimerTXDelay() {
    allowTX = false
    if timerTXDelay == nil {
      timerTXDelay = Timer.scheduledTimer(timeInterval: 5.0,
                                          target: self,
                                          selector: #selector(timerTXDelayElapsed),
                                          userInfo: nil,
                                          repeats: false)
    }

    toggleCommands(false)
  }

  func stopTimerTXDelay() {
    if timerTXDelay == nil { return }

    timerTXDelay?.invalidate()
    timerTXDelay = nil
    allowTX = true
    toggleCommands(true)
  }

  func toggleCommands(_ value: Bool) {
    chkButton.isEnabled = value
    batButton.isEnabled = value
    getButton.isEnabled = value
    tmpButton.isEnabled = value
    clrButton.isEnabled = value
    wipButton.isEnabled = value
    reqButton.isEnabled = value
    clkButton.isEnabled = value
  }

  func disconnect() {
    statusImg.image = #imageLiteral(resourceName: "error")
    nameLabel.isHidden = true
    uuidLabel.isHidden = true
    serviceLabel.isHidden = true
    characteristicLabel.isHidden = true
  }

  func connect() {
    statusImg.image = #imageLiteral(resourceName: "success")
    nameLabel.isHidden = false
    uuidLabel.isHidden = false
    serviceLabel.isHidden = false
    characteristicLabel.isHidden = false

    if let bleService = btDiscoverySharedInstance.service {
      nameLabel.text = "Connected to: " + (bleService.peripheral?.name)!
      uuidLabel.text = "UUID: " + (bleService.peripheral?.identifier.uuidString)!
      serviceLabel.text = "Service: " + ServiceUUID.uuidString
      characteristicLabel.text = "Characteristic: " + CharacteristicUUID.uuidString
    }
  }

}

