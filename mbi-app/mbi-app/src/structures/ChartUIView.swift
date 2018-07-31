//
//  ChartUIView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/23.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//


import UIKit

class ChartUIView: UIView {

  var biva: BIVA?
  var data: Exam?

  public func setData(_ data: Exam) {
    self.data = data
  }

  override func draw(_ rect: CGRect) {
    guard data != nil else { return }

    biva = BIVA(view: self, exam: data!)
    if let view = biva?.chart?.view {
      addSubview(view)
    }

    // draw impedances
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    let attributes = [
      NSAttributedStringKey.paragraphStyle: paragraphStyle,
      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 9.0),
      NSAttributedStringKey.foregroundColor: UIColor.lightGray
    ]

    if let impedances = data?.impedances_array {
      for (index, impedance) in impedances.enumerated() {
        let myText = String(format: "%0.3f-j%0.f", impedance.real, -impedance.imaginary)
        let attributedString = NSAttributedString(string: myText, attributes: attributes)

        attributedString.draw(in: CGRect(x: 38, y: 8 + 16 * (index), width: 200, height: 100))
      }
    }

    // draw ellipse
//    let rect = CGRect(x: bounds.width / 2 - 25,
//                      y: bounds.height / 2 - 50,
//                      width: 50,
//                      height: 100)
//    var t = CGAffineTransform(rotationAngle: 0)
//    let path = CGPath(ellipseIn: rect, transform: &t)
//
//    let layer = CAShapeLayer()
//    layer.path = path
//    layer.fillColor = UIColor.clear.cgColor
//    layer.strokeColor = UIColor.red.cgColor
//    layer.lineWidth = 2.0
//    self.layer.addSublayer(layer)
//    UIColor.gray.setFill()
  }

}
