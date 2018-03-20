//
//  Impedance.swift
//  mbi-app
//
//  Complete structure for Impedance data with calculation methods.
//
//  Created by 埜原菽也 on H30/03/17.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Darwin
import UIKit

struct Impedance {

  var real: Double
  var imaginary: Double

  // MARK: - Convenience Variables
  var module: Double! {
    get { return sqrt(pow2(real) + pow2(imaginary)) }
  }

  var phase: Double! {
    get { return atan(imaginary / real) }
  }

  fileprivate func pow2(_ x: Double) -> Double {
    return pow(x, 2)
  }

}

