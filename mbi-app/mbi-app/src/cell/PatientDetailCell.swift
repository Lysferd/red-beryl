//
//  PatientDetailCell.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/28.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientDetailCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!

  var title: String? {
    didSet { titleLabel.text = title }
  }

  var subtitle: String? {
    didSet { subtitleLabel.text = subtitle }
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
