//
//  ListExamView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/30.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ListExamView: UIViewController {

  // MARK: GUI Outlets
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var examsTable: UITableView!
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var trashButton: UIBarButtonItem!

  // MARK: Properties
  let datasource: ExamsDataSource

  // MARK: - Initialization
  required init?(coder aDecoder: NSCoder) {
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

    datasource.checkUpdate()
    if let index = examsTable.indexPathForSelectedRow {
      examsTable.deselectRow(at: index, animated: true)
    }
  }

  @IBAction func unwindToExamList(sender: UIStoryboardSegue) {
    if let source = sender.source as? NewExamView, let exam = source.exam {
      let newIndexPath = IndexPath(row: examsTable.numberOfRows(inSection: 0), section: 0)
      if datasource.append(exam) {
        examsTable.insertRows(at: [newIndexPath], with: .automatic)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "showDetailSegue" {
      if let index = examsTable.indexPathForSelectedRow {
        if let controller = segue.destination as? ExamDetailView {
          controller.exam = datasource.exams[index.row]
        }
      }
    }
  }

  @IBAction func refreshClicked(_ sender: Any) {
    datasource.reload()
    examsTable.reloadData()
  }

  @IBAction func trashClicked(_ sender: Any) {
    dbSharedInstance.dropAllExams()
    datasource.reload()
    examsTable.reloadData()
  }


}
