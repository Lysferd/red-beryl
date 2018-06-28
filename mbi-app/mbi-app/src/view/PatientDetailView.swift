//
//  PatientDetailView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/12.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PatientDetailView: UITableViewController {

  //
  // Valid patient must always be provided
  //
  var patient: Patient!

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = patient.fullname
    tableView.register(UINib(nibName: "ExamCell", bundle: nil), forCellReuseIdentifier: "ExamCell")
    tableView.register(UINib(nibName: "ActionCell", bundle: nil), forCellReuseIdentifier: "ActionCell")
  }

  //
  // MARK: Private
  //
  @IBAction func edit(_ sender: UIBarButtonItem) {
    // do smh
  }

  //
  // * Warn user prior to discarding data
  //
  @IBAction func deleteClicked(_ sender: UIButton) {
    let title = "Atenção"
    let message = "A remoção de um paciente também remove todos os exames " +
    "relacionados ao paciente.\nDeseja apagar o paciente?"

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Apagar", style: .destructive) { (_) in self.dropPatient() })
    self.present(alert, animated: true, completion: nil)
  }

  //
  // * Discard patient from data
  //
  fileprivate func dropPatient() {
    performSegue(withIdentifier: "delete", sender: self)
    navigationController?.popViewController(animated: true)
  }

  //
  // * Table Related
  //
  override func numberOfSections(in tableView: UITableView) -> Int {
    return patient.section_count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return patient.rowCount(forSection: section)
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return patient.title(forSection: section)
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  //
  // * Fill Cell
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let row = indexPath.row
    let section = indexPath.section

    switch indexPath.section {
    case Patient.Section.personal.rawValue, Patient.Section.medical.rawValue:
      var cell = tableView.dequeueReusableCell(withIdentifier: "PatientDetailCell") as! PatientDetailCell
      patient.populateData(forCell: &cell, atRow: row, inSection: section)
      return cell

    case Patient.Section.exams.rawValue:
      var cell = tableView.dequeueReusableCell(withIdentifier: "ExamCell") as! ExamCell
      patient.populateData(forCell: &cell, atRow: row, inSectio: section)
      return cell

    case Patient.Section.actions.rawValue:
      var cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell") as! ActionCell
      patient.populateData(forCell: &cell, atRow: row, inSection: section)
      cell.actionButton.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
      return cell

    default:
      break
    }

    return UITableViewCell()
  }

}
