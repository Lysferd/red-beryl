//
//  Measure.swift
//  mbi-app
//
//  Simple struct to present measurement data read from MBI into
//  the measures table. Does not represent the complete exam data.
//
//  Created by 埜原菽也 on H30/02/16.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

struct Measure {
  var date: String
  var frequency: Double
  var impedance: (real: Double, imaginary: Double)

  init(date: String, frequency: Double, impedance: (Double, Double)) {
    self.date = date
    self.frequency = frequency
    self.impedance = (real: impedance.0, imaginary: impedance.1)
  }
}
