//
//  ActionCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/04/25.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

  @IBOutlet weak var actionButton: UIButton!

  var caption: String! {
    didSet {
      let i18n = NSLocalizedString(caption, comment: caption)
      actionButton.setTitle(i18n, for: .normal)
    }
  }

  var icon: UIImage! {
    didSet { actionButton.setImage(icon, for: .normal) }
  }

  var color: UIColor! {
    didSet { actionButton.setTitleColor(color, for: .normal) }
  }

}
