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

  @IBAction func unwindToExamList(sender: UIStoryboardSegue) {
    if let source = sender.source as? NewExamView, let data = source.exam_data {
      datasource.append(data)
      examsTable.reloadData()
    }
  }

  @IBAction func trash(_ sender: UIBarButtonItem) {
    datasource.reset()
    examsTable.reloadData()
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
//    datasource.reload()
    examsTable.reloadData()
  }

  @IBAction func trashClicked(_ sender: Any) {
//    dbSharedInstance.dropAllExams()
//    datasource.reload()
    examsTable.reloadData()
  }


}
