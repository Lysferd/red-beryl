//
//  DetailCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/28.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

  @IBOutlet fileprivate weak var valueLabel: UILabel!
  @IBOutlet fileprivate weak var titleLabel: UILabel!

  var value: String? {
    didSet { valueLabel.text = value }
  }

  var title: String? {
    didSet { titleLabel.text = title }
  }

}
