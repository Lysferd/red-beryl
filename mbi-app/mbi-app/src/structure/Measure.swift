//
//  Measure.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/16.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation

class Measure {
  fileprivate let dateFormatIn = DateFormatter()
  fileprivate let dateFormatOut = DateFormatter()
  var date: Date
  var real: Double
  var imaginary: Double
  var frequency: Double


  init(real: Double, imaginary: Double, frequency: Double, date: String) {
    dateFormatIn.dateFormat = "dd/MM/yy HH:mm"
    dateFormatOut.dateFormat = "dd/MM/yy HH:mm"
    self.real = real
    self.imaginary = imaginary
    self.frequency = frequency
    self.date = dateFormatIn.date(from: date)!
  }

  public func getDateString() -> String {
    return dateFormatOut.string(from: date)
  }
}

func ==(lhs: Measure, rhs: Measure) -> Bool {
  return lhs.date == rhs.date && lhs.frequency == rhs.frequency && lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
}
