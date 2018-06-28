//
//  ListPatientView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ListPatientView: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: Properties
  let datasource: PatientsDataSource

  // MARK: - Initialization
  required init?(coder aDecoder: NSCoder) {
    datasource = PatientsDataSource()
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    tableView.dataSource = datasource
    tableView.reloadData()
  }

  // MARK: - Actions
  @IBAction func unwindToPatientList(sender: UIStoryboardSegue) {

    if let identifier = sender.identifier {
      switch identifier {
      case "create":
        if let source = sender.source as? NewPatientView, let data = source.patient_data {
          datasource.append(data)
          tableView.reloadData()
        }

      case "edit":
        return

      case "delete":
        if let source = sender.source as? PatientDetailView,
          let patient = source.patient {
          datasource.drop(patient)
          tableView.reloadData()
        }

      default:
        fatalError()
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "showDetailSegue" {
      if let index = tableView.indexPathForSelectedRow,
      let controller = segue.destination as? PatientDetailView {
        let key = datasource.sections[index.section]
        if let filter = datasource.patients[key] {
          controller.patient = filter[index.row]
        }
      }
    }
  }
}
