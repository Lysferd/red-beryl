//
//  PatientDetailDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/28.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientDetailDataSource: NSObject {

  var patient: Patient!

  init(_ patient: Patient) {
    self.patient = patient
  }

}

extension PatientDetailDataSource: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PatientDetailCell.self)) as! PatientDetailCell

    //    navigationItem.title = patient?.first_name
    //    recordLabel.text = patient?.record
    //    firstnameLabel.text = patient?.first_name
    //    middlenameLabel.text = patient?.middle_name
    //    lastnameLabel.text = patient?.last_name

    cell.title = "Testing"
    cell.subtitle = "Testing again"

    return cell
  }

}
