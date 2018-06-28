//
//  MeasureCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/16.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class MeasureCell: UITableViewCell {

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var realLabel: UILabel!
  @IBOutlet weak var imaginaryLabel: UILabel!

  var date: String? {
    didSet { dateLabel.text = date }
  }

  var frequency: Double? {
    didSet {
      if let text = frequency {
        frequencyLabel.text = "\(text)Hz"
      }
    }
  }

  var real: Double? {
    didSet {
      if let text = real {
        realLabel.text = "\(text)"
      }
    }
  }

  var imaginary: Double? {
    didSet {
      if let text = imaginary {
        imaginaryLabel.text = "-j\(-text)"
      }
    }
  }

}
