//
//  PatientListView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientListView: UIViewController {

  // MARK: GUI Outlets
  @IBOutlet weak var patientsTable: UITableView!

  // MARK: Properties
  let datasource: PatientsDataSource

  // MARK: - Initialization
  required init?(coder aDecoder: NSCoder) {
    let patients = [ Patient(record: "382", first_name: "Francisco", middle_name: "Alves", last_name: "Silva") ]
    datasource = PatientsDataSource([])//patients)
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    patientsTable.tableFooterView = UIView()
    patientsTable.dataSource = datasource
    patientsTable.reloadData()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let index = patientsTable.indexPathForSelectedRow {
      patientsTable.deselectRow(at: index, animated: true)
    }
  }

  // MARK: - Actions
  @IBAction func unwindToPatientList(sender: UIStoryboardSegue) {
    if let source = sender.source as? NewPatientView, let patient = source.patient {
      let newIndexPath = IndexPath(row: patientsTable.numberOfRows(inSection: 0), section: 0)
      if datasource.append(patient) {
        patientsTable.insertRows(at: [newIndexPath], with: .automatic)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "showDetailSegue" {
      let index = patientsTable.indexPathForSelectedRow
      let controller = segue.destination as? PatientDetailView
      controller?.patient = datasource.patients[index!.row]
    }
  }

}
