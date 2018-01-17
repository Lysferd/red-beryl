//
//  SectionImageView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/11/01.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit

class SectionImageView: UIImageView {
  
  override func layoutSubviews() {
    self.layer.cornerRadius = self.frame.size.height / 2
    self.clipsToBounds = true
  }
  
  /*
  // Only override draw() if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func draw(_ rect: CGRect) {
      // Drawing code
  }
  */

}
