//
//  ExamListView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/30.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ExamListView: UIViewController {

  // MARK: GUI Outlets
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var searchButton: UIBarButtonItem!
  @IBOutlet weak var examsTable: UITableView!

  // MARK: Properties
  let datasource: ExamsDataSource

  // MARK: - Initialization
  required init?(coder aDecoder: NSCoder) {
    //let exam = Exam(z_real: 1.0, z_imaginary: -1.0, frequency: 10, date: "12/12/12 02:54")
    datasource = ExamsDataSource()

    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    examsTable.tableFooterView = UIView()
    examsTable.dataSource = datasource
    examsTable.reloadData()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let index = examsTable.indexPathForSelectedRow {
      examsTable.deselectRow(at: index, animated: true)
    }
  }
}
