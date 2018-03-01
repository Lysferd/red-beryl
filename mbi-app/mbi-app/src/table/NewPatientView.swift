//
//  NewPatientView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit

class NewPatientView: UITableViewController {
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!

  @IBOutlet weak var recordTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var middleNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var personalIdTextField: UITextField!
  
  var patient: Patient?
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    guard let button = sender as? UIBarButtonItem,
      button == saveButton else { return }
    
    let record = recordTextField.text! // obligatory
    let firstName = firstNameTextField.text! // obligatory
    let middleName = middleNameTextField.text ?? ""
    let lastName = lastNameTextField.text ?? ""
    let personalId = ""
    let birthDate = ""
    let phoneNumber = ""
    let email = ""
    let address = ""
    let city = ""
    let state = ""
    let country = ""
    let bloodType = ""
    let riskGroups = ""
    let regularMedication = ""
    let registerDate = Date()
    let updateDate = Date()
    let examIds: [Int] = []

    patient = Patient(record: record, first_name: firstName, middle_name: middleName, last_name: lastName, personal_id: personalId, birth_date: birthDate, phone_number: phoneNumber, email: email, address: address, city: city, state: state, country: country, blood_type: bloodType, risk_groups: riskGroups, regular_medication: regularMedication, register_date: registerDate, update_date: updateDate, exam_ids: examIds)
  }

  // MARK: - Actions
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    updateSaveButtonState()
  }

  // MARK: - Private Methods
  private func updateSaveButtonState() {
    saveButton.isEnabled = !(recordTextField.text!.isEmpty || firstNameTextField.text!.isEmpty)
  }
}

