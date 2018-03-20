//
//  ExamDetailView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/09.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

enum MyExampleModelDataType {
  case type0, type1, type2, type3
}

enum Shape {
  case triangle, square, circle, cross
}

class ExamDetailView: UIViewController {

//  @IBOutlet weak var nameLabel: UILabel!
//  @IBOutlet weak var dateLabel: UILabel!
//  @IBOutlet weak var segmentLabel: UILabel!
//  @IBOutlet weak var impedanceLabel: UILabel!
//  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var chartView: UIView!
  var exam: Exam?
  var biva: BIVA?

  override func viewDidLoad() {
    super.viewDidLoad()

    guard exam != nil else { return }

//    nameLabel.text = exam?.getPatient().full_name()
//    dateLabel.text = exam?.dateString()
//    segmentLabel.text = exam?.segmentString()
//    impedanceLabel.text = exam?.impedanceString()
//    frequencyLabel.text = exam?.frequencyString()

    if let model = exam?.impedances, let height = exam?.height {
      biva = BIVA(view: chartView, model: model, height: height / 1e2)
      if let view = biva?.chart?.view {
        chartView.addSubview(view)
      }
    }
  }


}
