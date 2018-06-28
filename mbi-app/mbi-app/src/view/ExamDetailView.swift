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
    detailTable.register(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
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

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as! BasicCell

    switch indexPath.row {
    case 0: cell.label = "Patient: \(exam.patient?.fullname ?? "Unknown")"
    case 1: cell.label = "Date: \(exam.date_string!)"
    case 2: cell.label = "Height: \(exam.height) cm"
    case 3: cell.label = "Weight: \(exam.weight) kg"
    case 4: cell.label = "TBW: \(exam.tbw!)"
    case 5: cell.label = "FFM: \(exam.ffm!)"
    case 6: cell.label = "FM: \(exam.fm!)"
    case 7: cell.label = "BodyFat%: \(exam.bodyfat!)"
    default: cell.label = "default"
    }

    return cell
  }


}
