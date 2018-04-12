//
//  ChartUIView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/23.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ChartUIView: UIView {

  override func draw(_ rect: CGRect) {
    var ovalPath = UIBezierPath(ovalIn: CGRect(x: 160, y: 160, width: 240, height: 320))
    UIColor.gray.setFill()
    ovalPath.fill()
  }

}
