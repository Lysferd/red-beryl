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

  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) {
    let patients = [ Patient(record: "382", first_name: "Francisco", middle_name: "Alves", last_name: "Silva") ]
    datasource = PatientsDataSource(patients)
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    patientsTable.tableFooterView = UIView()
    patientsTable.dataSource = datasource
    patientsTable.reloadData()
  }

}
