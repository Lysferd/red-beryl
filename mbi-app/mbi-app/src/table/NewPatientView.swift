//
//  NewPatientView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/17.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class NewPatientView: UITableViewController {

  // MARK: UI Outlets
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var recordTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var middleNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var personalIdTextField: UITextField!

  // MARK: Patient Object
  var patient: Patient?

  // MARK: UITextFieldDelegate
  @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    updateSaveButtonState()
  }

  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    guard let button = sender as? UIBarButtonItem, button == saveButton else {
      return
    }

    let record = recordTextField.text!
    let firstName = firstNameTextField.text!
    let middleName = middleNameTextField.text!
    let lastName = lastNameTextField.text!
    //let personalId = personalIdTextField.text

    patient = Patient(record: record,
                      first_name: firstName,
                      middle_name: middleName,
                      last_name: lastName)
  }

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: Private Methods
  private func updateSaveButtonState() {
    saveButton.isEnabled = !(recordTextField.text!.isEmpty || firstNameTextField.text!.isEmpty)
  }

}
