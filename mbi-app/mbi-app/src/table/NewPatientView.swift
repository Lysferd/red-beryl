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

    patient = Patient(record: record,
                      first_name: firstName,
                      middle_name: middleName,
                      last_name: lastName)
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

