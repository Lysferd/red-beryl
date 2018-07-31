//
//  ExamDetailView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/09.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import SwiftCharts

class ExamDetailView: UIViewController {

  @IBOutlet weak var chartView: ChartUIView!
  @IBOutlet weak var detailTable: UITableView!

  var exam: Exam!

  override func viewWillAppear(_ animated: Bool) {
    detailTable.dataSource = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    chartView.setData(exam)
  }

}

extension ExamDetailView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Patient Data"
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell

    var title: String
    var value: String

    switch indexPath.row {
      case 0:
        title = NSLocalizedString("patient", comment: "patient")
        value = exam.patient?.fullname ?? "?Name?"
      case 1:
        title = NSLocalizedString("date", comment: "date")
        value = exam.date_string
      case 2:
        title = NSLocalizedString("height", comment: "height")
        value = String(format: "%.2f cm", exam.height)
      case 3:
        title = NSLocalizedString("weight", comment: "weight")
        value = String(format: "%.2f kg", exam.weight)
      case 4:
        title = NSLocalizedString("tbw", comment: "tbw")
        value = String(format: "%.3f kg", exam.tbw)
      case 5:
        title = NSLocalizedString("ffm", comment: "ffm")
        value = String(format: "%.3f kg", exam.ffm)
      case 6:
        title = NSLocalizedString("fm", comment: "fm")
        value = String(format: "%.3f kg", exam.fm)
      case 7:
        title = NSLocalizedString("bm", comment: "bm")
        value = String(format: "%.3f %%", exam.bodyfat)
      default:
        title = "default"
        value = "nothing"
    }

    cell.title = title
    cell.value = value
    return cell
  }

}
