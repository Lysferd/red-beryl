//
//  BasicCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/05/03.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {

  @IBOutlet fileprivate weak var titleLabel: UILabel!

  var label: String? {
    didSet {
      titleLabel.text = label
    }
  }

}
