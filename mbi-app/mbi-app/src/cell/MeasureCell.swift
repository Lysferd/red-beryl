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

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    selectionStyle = .none
  }

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

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

//    self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//    UIView.animate(withDuration: 0.4) {
//      self.transform = CGAffineTransform.identity
//    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    if selected {
      accessoryType = .checkmark
    } else {
      accessoryType = .none
    }
  }

}
