//
//  NewPatientView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit

class NewPatientView: UITableViewController {

  //
  // * Outlets

  // * Action Buttons
  @IBOutlet fileprivate weak var saveButton: UIBarButtonItem!
  @IBOutlet fileprivate weak var cancelButton: UIBarButtonItem!
  @IBOutlet fileprivate var keyboardToolbar: UIToolbar!

  // * Textfields
  @IBOutlet fileprivate var textFields: [UITextField]!

  // deprecated?
  @IBOutlet fileprivate var pickerFields: [UITextField]!
  @IBOutlet fileprivate var pickerViews: [Any]!

  // * Selectors
  @IBOutlet fileprivate weak var countryLabel: UILabel!
  @IBOutlet fileprivate weak var riskGroupLabel: UILabel!
  @IBOutlet fileprivate weak var medicationLabel: UILabel!

  // * Birthdate Picker
  @IBOutlet fileprivate var datePicker: UIDatePicker!
  @IBOutlet fileprivate weak var dateTextField: UITextField!

  // * Gender Picker
  @IBOutlet fileprivate weak var genderTextField: UITextField!
  @IBOutlet fileprivate var genderPicker: UIPickerView!

  // * BloodType Picker
  @IBOutlet fileprivate weak var bloodtypeTextField: UITextField!
  @IBOutlet fileprivate var bloodtypePicker: BloodtypePicker!

  // * Ethnicity Picker
  @IBOutlet fileprivate weak var ethnicityTextField: UITextField!
  @IBOutlet fileprivate var ethnicityPicker: UIPickerView!

  //
  // * Consts
  fileprivate enum Sections { case personal, medical }

  //
  // * Vars
  var patient_data: Dictionary<String, Any?>?
  fileprivate var activeTextField: UITextField!
  fileprivate var selectedCountry: String? = NSLocale.current.regionCode
  fileprivate var selectedRiskGroups: [String]?
  fileprivate var selectedMedications: [String]?

  //
  // * Initializer
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextFields()

    tableView.keyboardDismissMode = .interactive
  }

  // * TableCell Tagging
  // Automate cell tagging.
  fileprivate func tagCells() {
    for i in 0..<tableView.numberOfSections {
      for j in 0..<tableView.numberOfRows(inSection: i) {
        let index = IndexPath(row: j, section: i)
        if let cell = tableView.cellForRow(at: index) {
          cell.tag = j
        }
      }
    }
  }

  // * Setup form fields.
  fileprivate func setupTextFields() {

    // Setup TextFields
    for (index, field) in textFields.enumerated() {
      field.delegate = self
      field.tag = index
      field.inputAccessoryView = keyboardToolbar
      field.returnKeyType = .next
    }
    textFields.last?.returnKeyType = .done

    // Setup PickerViews/PickerFields
//    for (index, picker) in pickerFields.enumerated() {
//      picker.inputView = pickerViews[index] as? UIView
//      picker.inputAccessoryView = keyboardToolbar
//    }

    // Setup Selections
    if let country = selectedCountry {
      countryLabel.text = NSLocale.current.localizedString(forRegionCode: country)
    }

    dateTextField.inputView = datePicker
    dateTextField.inputAccessoryView = keyboardToolbar

    genderTextField.inputView = genderPicker
    genderTextField.inputAccessoryView = keyboardToolbar

    bloodtypeTextField.inputView = bloodtypePicker
    bloodtypeTextField.inputAccessoryView = keyboardToolbar

    ethnicityTextField.inputView = ethnicityPicker
    ethnicityTextField.inputAccessoryView = keyboardToolbar
  }

  //
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case is SelectCountryView:
      if let dest = segue.destination as? SelectCountryView {
        dest.selection = selectedCountry
      }

    case is SelectRiskGroupsView:
      if let dest = segue.destination as? SelectRiskGroupsView {
        dest.selection = selectedRiskGroups
      }

    case is SelectMedicationsView:
      if let dest = segue.destination as? SelectMedicationsView {
        dest.selection = selectedMedications
      }

    default:
      guard let button = sender as? UIBarButtonItem, button == saveButton else { return }
      
      var data: Dictionary<String, Any> = [:]
      data["record"] = textFields[0].text
      data["firstName"] = textFields[1].text
      data["middleName"] = textFields[2].text
      data["lastName"] = textFields[3].text
      data["personalId"] = textFields[4].text
      data["phoneNumber"] = textFields[5].text
      data["email"] = textFields[6].text
      data["address"] = textFields[7].text
      data["city"] = textFields[8].text
      data["state"] = textFields[9].text
      data["country"] = selectedCountry
      data["birthDate"] = dateTextField.text
      data["gender"] = genderTextField.text
      data["bloodType"] = bloodtypeTextField.text
      data["ethnicity"] = ethnicityTextField.text
//      data["riskGroups"] = selectedRiskGroups
//      data["regularMedications"] = selectedMedications

      patient_data = data
    }
  }

  //
  @IBAction func unwindToNewPatient(sender: UIStoryboardSegue) {
    switch sender.source {
    case is SelectCountryView:
      let source = sender.source as! SelectCountryView
      if let country = source.selection {
        selectedCountry = country
        countryLabel.text = NSLocale.current.localizedString(forRegionCode: country)
      }

    case is SelectRiskGroupsView:
      let source = sender.source as! SelectRiskGroupsView
      if let riskGroups = source.selection {
        selectedRiskGroups = riskGroups
        riskGroupLabel.text = riskGroups.joined(separator: ", ")
      }

    case is SelectMedicationsView:
      let source = sender.source as! SelectMedicationsView
      if let medications = source.selection {
        selectedMedications = medications
        medicationLabel.text = medications.joined(separator: ", ")
      }
      
    default:
      fatalError()
    }
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
    saveButton.isEnabled = !(textFields[0].text!.isEmpty || textFields[1].text!.isEmpty)
  }

  //
  // * TableView Delegation
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    //
    switch indexPath.section {
    case 0:
      if let tag = tableView.cellForRow(at: indexPath)?.tag {
        if tag >= 0 {
          textFields[tag].becomeFirstResponder()
        } else {
          self.view.endEditing(true)
        }
      }

    case 1:
      if let tag = tableView.cellForRow(at: indexPath)?.tag {
        if tag >= 0 {
          pickerFields[tag].becomeFirstResponder()
        } else {
          self.view.endEditing(true)
        }
      }

    default:
      return
    }
  }

  //
  // * Keyboard
  //
  @IBAction func doneClicked(_ sender: UIBarButtonItem) {
    self.view.endEditing(true)
  }

  @IBAction func changedDate(_ sender: UIDatePicker) {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    dateTextField.text = formatter.string(from: sender.date)
  }

}

//
// * TextField Delegation
//
extension NewPatientView: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let tag = textField.tag + 1
    if tag == textFields.count {
      self.view.endEditing(true)
    } else {
      textFields[tag].becomeFirstResponder()
    }

    return true
  }

}

//
// * PickerView Delegation
//
extension NewPatientView: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if row == 0 { return }

    switch pickerView {
    case is GenderPicker:
      let picker = pickerView as! GenderPicker
      genderTextField.text = picker.choices[row-1]

    case is BloodtypePicker:
      let picker = pickerView as! BloodtypePicker
      bloodtypeTextField.text = picker.choices[row-1]

    case is EthnicityPicker:
      let picker = pickerView as! EthnicityPicker
      ethnicityTextField.text = picker.choices[row-1]

    default:
      fatalError()
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    switch pickerView {
    case is GenderPicker:
      let picker = pickerView as! GenderPicker
      return picker.titleForRow(row, forComponent: component)

    case is BloodtypePicker:
      let picker = pickerView as! BloodtypePicker
      return picker.titleForRow(row, forComponent: component)

    case is EthnicityPicker:
      let picker = pickerView as! EthnicityPicker
      return picker.titleForRow(row, forComponent: component)

    default:
      fatalError()
    }
  }
}
