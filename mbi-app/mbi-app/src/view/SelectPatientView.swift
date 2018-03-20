//
//  SelectPatientView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/28.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class SelectPatientView: UIViewController {

  @IBOutlet weak var patientsTable: UITableView!
  let datasource: PatientsDataSource
  public var selection: Patient?

  required init?(coder aDecoder: NSCoder) {
    datasource = PatientsDataSource(selectable: true)
    
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    patientsTable.tableFooterView = UIView()
    patientsTable.dataSource = datasource
    patientsTable.reloadData()

    super.viewDidLoad()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if let index = patientsTable.indexPathForSelectedRow {
      selection = datasource[index]
    }
  }

}
