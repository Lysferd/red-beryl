//
//  NewExamView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/15.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

typealias RawGTXData = (date: String, frequency: Double, impedances: [Impedance])
typealias RawGETData = (date: String, frequency: Double, impedance: Impedance)

class NewExamView: UITableViewController {

  fileprivate var queue = DispatchQueue.main

  @IBOutlet weak var selectedPatientLabel: UILabel!
  @IBOutlet weak var selectedSegmentLabel: UILabel!
  @IBOutlet weak var selectedMeasureLabel: UILabel!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var weightTextField: UITextField!

  var exam: Exam?
  var selectedPatient: Patient?
  var selectedSegment: Int?
  var selectedMeasure: RawGTXData?

  override func viewDidLoad() {
    NotificationCenter.default.addObserver(self, selector: #selector(updateGTX(_:)), name: BLEUpdateGTX, object: nil)

    super.viewDidLoad()

    selectedPatientLabel.text = ""
    selectedSegmentLabel.text = ""
    selectedMeasureLabel.text = ""
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    guard let button = sender as? UIBarButtonItem,
      button == saveButton else { return }

    let patient_id = selectedPatient?.row_id
    let segment = selectedSegment
    let height = Double(heightTextField.text!)
    let weight = Double(weightTextField.text!)

    if let id = patient_id, let seg = segment, let h = height, let w = weight,
      let m = selectedMeasure {
      exam = Exam(
        patient_id: id,
        segment: seg,
        height: h,
        weight: w,
        date_string: m.date,
        frequency: m.frequency,
        impedances: m.impedances
      )
    }
  }

  @IBAction func unwindToNewExam(sender: UIStoryboardSegue) {
    switch sender.source {
    case is SelectPatientView:
      let source = sender.source as! SelectPatientView
      if let patient = source.selection {
        selectedPatient = patient
        selectedPatientLabel.text = patient.first_name
      }

    case is SelectSegmentView:
      let source = sender.source as! SelectSegmentView
      if let segment = source.selection {
        selectedSegment = segment
        selectedSegmentLabel.text = Constants.segments[segment]
      }

    case is SelectMeasureView:
      let source = sender.source as! SelectMeasureView
      if let index = source.selection {
        if let service = btDiscoverySharedInstance.service {
          service.write("GTX", with: index)
        }
      }

    default:
      fatalError("Returning from unknown controller source!")
    }

    editingChanged()
  }

  @IBAction func cancelClicked(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func editingChanged() {
    updateSaveButtonState()
  }

  // MARK: - Private Methods
  private func updateSaveButtonState() {
    saveButton.isEnabled = (selectedPatient != nil && selectedSegment != nil && selectedMeasure != nil && !(heightTextField.text!.isEmpty || weightTextField.text!.isEmpty))
  }

  @objc func updateGTX(_ notification: Notification) {
    let info = notification.userInfo as! [String: RawGTXData]

    queue.async {
      if let measure = info["measure"] {
        self.selectedMeasure = measure
        self.selectedMeasureLabel.text = "1 medição"

        // disconnect from mbi
        btDiscoverySharedInstance.disconnect()
      }
    }
  }

}
