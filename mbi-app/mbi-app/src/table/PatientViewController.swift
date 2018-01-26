//
//  PatientViewController.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit
import os.log

class NewPatientViewController: UIViewController {
  
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
    
    guard let button = sender as? UIBarButtonItem, button == saveButton else {
      os_log("Save button not pressed. Cancelling.", log: OSLog.default, type: .debug)
      return
    }
    
    let record = recordTextField.text ?? ""
    let firstName = firstNameTextField.text ?? ""
    let middleName = middleNameTextField.text ?? ""
    let lastName = lastNameTextField.text ?? ""
    //let personalId = personalIdTextField.text
    
    patient = Patient(record: record, first_name: firstName, middle_name: middleName, last_name: lastName)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

