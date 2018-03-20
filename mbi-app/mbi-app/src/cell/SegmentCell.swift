//
//  SegmentCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/08.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class SegmentCell: UITableViewCell {

  // MARK: Properties
  @IBOutlet weak var nameLabel: UILabel!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    selectionStyle = .none
  }

  var name: String? {
    didSet { nameLabel.text = name }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
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
