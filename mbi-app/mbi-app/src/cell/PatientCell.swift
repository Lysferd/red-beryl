//
//  PatientCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientCell: UITableViewCell {
  
  // MARK: Properties
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var listCell: UIView!

  var name: String? {
    didSet { nameLabel.text = name }
  }

}
