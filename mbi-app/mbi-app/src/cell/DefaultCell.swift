//
//  DefaultCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/04/05.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class DefaultCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!

  var contents: String? {
    didSet { titleLabel.text = contents }
  }

}
