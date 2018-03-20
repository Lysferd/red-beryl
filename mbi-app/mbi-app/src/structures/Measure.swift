//
//  Measure.swift
//  mbi-app
//
//  Simple struct to present measurement data read from MBI.
//
//  Created by 埜原菽也 on H30/02/16.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

struct Measure {
  var date: String
  var frequency: Double
  var impedances: [Impedance]

  init(date: String, frequency: Double, impedances: [Impedance]) {
    self.date = date
    self.frequency = frequency
    self.impedances = impedances
  }
}
