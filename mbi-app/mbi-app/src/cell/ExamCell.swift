//
//  ExamCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/06.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ExamCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var readingLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

  var name: String? {
    didSet { nameLabel.text = name }
  }

  var reading: String? {
    didSet { readingLabel.text = reading }
  }

  var date: String? {
    didSet { dateLabel.text = date }
  }

}
