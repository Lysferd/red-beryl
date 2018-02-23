//
//  Exam.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/30.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation

class Exam {
  var patient: Patient
  var measure: Measure

  init(patient: Patient, measure: Measure) {
    self.patient = patient
    self.measure = measure
  }
}

func ==(lhs: Exam, rhs: Exam) -> Bool {
  return lhs.patient == rhs.patient && lhs.measure == rhs.measure
}
