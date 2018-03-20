//
//  SelectableCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/06.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class SelectableCell: UITableViewCell {

  // MARK: Properties
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var listCell: UIView!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    selectionStyle = .none
  }

  var name: String? {
    didSet { nameLabel.text = name }
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
