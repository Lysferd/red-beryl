//
//  NewExamView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/15.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class NewExamView: UITableViewController {

  @IBOutlet weak var selectedPatientLabel: UILabel!
  @IBOutlet weak var selectedSegmentLabel: UILabel!
  @IBOutlet weak var selectedMeasureLabel: UILabel!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var weightTextField: UITextField!

  var exam: Exam?
  var selectedPatient: Patient?
  var selectedSegment: Int?
  var selectedMeasure: Measure?

  override func viewDidLoad() {
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
      if let measure = source.selection {
        selectedMeasure = measure
        selectedMeasureLabel.text = "1 medição"
      }

    default:
      return
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

}
