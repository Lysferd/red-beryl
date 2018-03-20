//
//  PatientDetailView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/12.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientDetailView: UITableViewController {

  @IBOutlet weak var recordLabel: UILabel!
  @IBOutlet weak var firstnameLabel: UILabel!
  @IBOutlet weak var middlenameLabel: UILabel!
  @IBOutlet weak var lastnameLabel: UILabel!

  var patient: Patient?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = patient?.first_name
    recordLabel.text = patient?.record
    firstnameLabel.text = patient?.first_name
    middlenameLabel.text = patient?.middle_name
    lastnameLabel.text = patient?.last_name
  }

  // MARK: Private
  @IBAction func edit(_ sender: UIBarButtonItem) {
    /*
    if (tableView.isEditing) {
      tableView.setEditing(false, animated: true)
      sender.title = "Done"
    } else {
      tableView.setEditing(true, animated: true)
      sender.title = "Edit"
    }
    */
  }
}
