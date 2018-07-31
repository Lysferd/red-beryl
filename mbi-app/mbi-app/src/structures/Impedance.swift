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
import CoreData

extension Impedance {
  var module: Double! {
    return sqrt(pow2(real) + pow2(imaginary))
  }

  var phase: Double! {
    return atan(imaginary / real)
  }

  var creal: Double! {
    return real / height
  }

  var cimaginary: Double! {
    return imaginary / height
  }

  var cimpedance: Double! {
    return module * 1.0
  }

  var height: Double! {
    guard let e = exam else { return 1.0 }
    return e.height
  }

  // Convenience:
  fileprivate func pow2(_ x: Double) -> Double {
    return pow(x, 2)
  }
}
