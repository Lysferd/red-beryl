//
//  ListPatientView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ListPatientView: UIViewController {

  // MARK: GUI Outlets
  @IBOutlet weak var patientsTable: UITableView!

  // MARK: Properties
  let datasource: PatientsDataSource

  // MARK: - Initialization
  required init?(coder aDecoder: NSCoder) {
    datasource = PatientsDataSource()
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
      if let index = patientsTable.indexPathForSelectedRow {
        if let controller = segue.destination as? PatientDetailView {
          controller.patient = datasource.patients[index.row]
        }
      }
    }
  }

  @IBAction func destroyTable(_ sender: Any) {
    NSLog("Dropping all rows")
    dbSharedInstance.dropAllPatients()
    datasource.reload()
    patientsTable.reloadData()
  }

  @IBAction func refreshTable(_ sender: Any) {
    NSLog("Reloading rows")
    datasource.reload()
    patientsTable.reloadData()
  }

}
