//
//  ExamDetailView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/09.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ExamDetailView: UIViewController {

  @IBOutlet weak var chartView: ChartUIView!
  var exam: Exam?
  var biva: BIVA?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let e = exam {
      chartView.setData(e)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

}
