//
//  PatientsDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientsDataSource: NSObject {
  var patients: [Patient]

  init(_ patients: [Patient]) {
    self.patients = patients
  }

  func append(_ patient: Patient) -> Bool {
    if patients.contains(where: { $0 == patient }) { return false }
    patients.append(patient)
    return true
  }
}

extension PatientsDataSource: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if patients.count == 0 {
      let emptyLabel = UILabel()
      emptyLabel.numberOfLines = 0
      emptyLabel.font = UIFont.systemFont(ofSize: 14)
      emptyLabel.text = "Não há pacientes cadastrados.\nToque “+” para cadastrar um novo paciente."
      emptyLabel.textAlignment = .center
      tableView.backgroundView = emptyLabel
      tableView.separatorStyle = .none
    } else {
      tableView.separatorStyle = .singleLine
      tableView.backgroundView = nil
    }

    return patients.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PatientCell.self)) as! PatientCell
    let patient = patients[indexPath.row]
    cell.name = patient.first_name + " " + patient.last_name
    return cell
  }
}
