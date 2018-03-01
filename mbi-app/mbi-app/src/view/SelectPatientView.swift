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

  required init?(coder aDecoder: NSCoder) {
    datasource = PatientsDataSource([])
    
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    patientsTable.tableFooterView = UIView()
    patientsTable.dataSource = datasource
    patientsTable.reloadData()

    super.viewDidLoad()
  }

}
