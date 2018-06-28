//
//  ExamCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/04/25.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ExamCell: UITableViewCell {

  @IBOutlet fileprivate weak var nameLabel: UILabel!
  @IBOutlet fileprivate weak var readingLabel: UILabel!
  @IBOutlet fileprivate weak var dateLabel: UILabel!

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
