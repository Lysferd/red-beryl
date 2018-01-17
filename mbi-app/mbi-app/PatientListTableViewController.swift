//
//  PatientListTableViewController.swift
//  mbi-app
//
//  Table View Controller related to the initial list of patients.
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientListTableViewController: UITableViewController {

  @IBOutlet var table: UITableView!

  // MARK: Properties
  var patients = [Patient]()
  var patient: Patient?
  
  // MARK: Private Methods
  private func loadSamplePatients() {
    guard let p1 = Patient(record: "382716", first_name: "Marmelada",
                           middle_name: "de Batata", last_name: "Doce")
      else { fatalError("Unable to instantiate p1") }
    guard let p2 = Patient(record: "217794", first_name: "Risoto",
                           middle_name: "de Frango", last_name: "Cozido")
      else { fatalError("Unable to instantiate p2") }
    guard let p3 = Patient(record: "843957", first_name: "Café",
                           middle_name: "Damasco", last_name: "Vegetariano")
      else { fatalError("Unable to instantiate p3") }
    
    patients += [ p1, p2, p3 ]
  }
  
  // MARK: Actions
  @IBAction func unwindToPatientList(sender: UIStoryboardSegue) {
    if let source = sender.source as? NewPatientTableViewController, let patient = source.patient {
      let newIndexPath = IndexPath(row: patients.count, section: 0)
      patients.append(patient)
      tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "showDetailSegue" {
      if let cell = sender as? UITableViewCell {
        if let index = tableView.indexPath(for: cell) {
          patient = patients[index.row]
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    table.tableFooterView = UIView()
    
    loadSamplePatients()

    if patients.count == 0 {
      table.isHidden = true
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return patients.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "PatientListTableViewCell"
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PatientListTableViewCell else { fatalError("The dequeued cell is not an instance of PatientListTableViewCell.") }
    
    let patient = patients[indexPath.row]
    cell.nameLabel.text = patient.first_name + " " + patient.last_name
    
    return cell
  }
  
}
