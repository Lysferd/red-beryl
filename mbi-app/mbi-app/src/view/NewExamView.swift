//
//  NewExamView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/15.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import CoreData

typealias RawImpedance = (real: Double, imaginary: Double)
typealias RawGTXData = (date: String, frequency: Double, impedances: [RawImpedance])
typealias RawGETData = (date: String, frequency: Double, impedance: RawImpedance)

class NewExamView: UITableViewController {

  @IBOutlet weak var selectedPatientLabel: UILabel!
  @IBOutlet weak var selectedSegmentLabel: UILabel!
  @IBOutlet weak var selectedMeasureLabel: UILabel!

  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var weightTextField: UITextField!

  @IBOutlet weak var measureCell: UITableViewCell!
  @IBOutlet weak var measureCellLabel: UILabel!
  @IBOutlet var keyboardToolbar: UIToolbar!

  var exam_data: Dictionary<String, Any?>?
  var selectedPatient: Patient?
  var selectedSegment: Int?
  var selectedMeasure: RawGTXData?
  var measureIndex: Int?

  // Initialization
  override func viewDidLoad() {
    // Observers
    observer(for: BLEUpdateGTX, function: #selector(updateGTX(_:)))
    observer(for: BLEConnected, function: #selector(connected(_:)))

    // Selectors
    selectedPatientLabel.text = ""
    selectedSegmentLabel.text = ""
    selectedMeasureLabel.text = ""

    // TextFields
    tableView.keyboardDismissMode = .interactive
    heightTextField.inputAccessoryView = keyboardToolbar
    weightTextField.inputAccessoryView = keyboardToolbar

    // BLE
    _ = btDiscoverySharedInstance
    btDiscoverySharedInstance.startScanning()

    // Super
    super.viewDidLoad()
  }

  // Creating new exam data
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let button = sender as? UIBarButtonItem, button == saveButton else { return }

    // Delete measure from MBI
    if let service = btDiscoverySharedInstance.service,
      let index = measureIndex {
      service.write("CLR", with: index)
    }
    
    // ORGANIZE DATA
    var data: Dictionary<String, Any> = [:]

    if let height = heightTextField.text { data["height"] = Double(height) }
    if let weight = weightTextField.text { data["weight"] = Double(weight) }
    data["date"] = Date()

    if let patient = selectedPatient {
      data["patient"] = patient
    }

    if let impedances = selectedMeasure?.impedances {
      data["impedances"] = impedances
    }

    exam_data = data

    btDiscoverySharedInstance.disconnect()
    releaseObservers()
  }

  // Selection unwinding
  @IBAction func unwindToNewExam(sender: UIStoryboardSegue) {
    switch sender.source {
    case is SelectPatientView:
      let source = sender.source as! SelectPatientView
      if let patient = source.selectedPatient {
        selectedPatient = patient
        selectedPatientLabel.text = patient.firstName
        updateSaveButtonState()
      }

    case is SelectSegmentView:
      let source = sender.source as! SelectSegmentView
      if let segment = source.selection {
        selectedSegment = segment
        selectedSegmentLabel.text = Constants.segments[segment]
        updateSaveButtonState()
      }

    case is SelectMeasureView:
      let source = sender.source as! SelectMeasureView
      if let index = source.selection {
        measureIndex = index.row + 1
        selectedMeasureLabel.text = "1 medição"
        if let service = btDiscoverySharedInstance.service {
          service.write("GTX", with: measureIndex)
        }
      }

    default:
      fatalError("Returning from unknown controller source")
    }

  }

  // Button Actions
  @IBAction func doneClicked(_ sender: UIBarButtonItem) {
    self.view.endEditing(true)
  }

  @IBAction func cancelClicked(_ sender: Any) {
    btDiscoverySharedInstance.disconnect()
    dismiss(animated: true, completion: nil)
  }

  @IBAction func editingChanged() {
    updateSaveButtonState()
  }

  // Table delegations
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
      case 0: heightTextField.becomeFirstResponder()
      case 1: weightTextField.becomeFirstResponder()
      default: self.view.endEditing(true)
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: - Private Methods
  func updateSaveButtonState() {
    saveButton.isEnabled = (selectedPatient != nil &&
      selectedSegment != nil &&
      selectedMeasure != nil &&
      !(heightTextField.text!.isEmpty || weightTextField.text!.isEmpty))
  }

  // MARK: - Observers
  @objc func connected(_ notification: Notification) {
    let info = notification.userInfo as! [String: Bool]

    async {
      if let connected = info["connected"], connected == true {
        self.measureCellLabel.isEnabled = true
        self.tableView.footerView(forSection: 0)?.textLabel?.text = NSLocalizedString("mbiConnected", comment: "mbiConnected")
        self.measureCell.isUserInteractionEnabled = true
      }
    }
  }

  @objc func updateGTX(_ notification: Notification) {
    let info = notification.userInfo as! [String: RawGTXData]

    async {
      if let measure = info["measure"] {
        self.selectedMeasure = measure
        self.updateSaveButtonState()
      }
    }
  }

}

// TextField Delegation
extension NewExamView: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField.tag {
    case 1: weightTextField.becomeFirstResponder()
    default: self.view.endEditing(true)
    }

    return true
  }

}

