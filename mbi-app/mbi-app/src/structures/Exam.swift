//
//  Exam.swift
//  mbi-app
//
//  `Exam' is a container class for multiple bioimpedance `Measures' made
//  on a single patient at a given moment in time.
//
//  Created by 埜原菽也 on H30/01/30.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation

class Exam {

  // Array of measure pairs
  //  First element [0] is always the ARITHMETIC MEAN,
  // subsequent elements [1...-1] are measured impedance values
  //  By default the MBI will always perform 10 measures during sweep,
  // so this Array will always have `11' elements.
//  typealias Data = [Impedance]

  fileprivate let date_format = DateFormatter()

  // DB Variables
  var row_id: Int?        // Self-reference in the DB Table
  var patient_id: Int     // Reference to patient in the DB Table

  var segment: Int            // FIXME: Use Struct
  var height: Double          // Patient height measured
  var weight: Double          // Patient weight measured
  var date: Date              // Date/Time patient was measured
  var frequency: Double       // Frequency of bioimpedance measure
  var impedances: [Impedance] // (Real,Imaginary) Double Pairs

  // MARK: - Convenience Variables
  var patient_name: String! {
    get { return patient().full_name() }
  }

  var date_string: String! {
    get { return date_format.string(from: date) }
  }

  var segment_string: String! {
    get { return Constants.segments[segment] }
  }

  var impedance_string: String! {
    get {
      let real = impedances[0].real / 1e3
      let imag = -impedances[0].imaginary / 1e3
      return String(format: "%.3f - j%.3f KΩ", real, imag)
    }
  }

  var frequency_string: String! {
    get {
      let freq = frequency / 1e3
      return String(format: "%.f KHz", freq)
    }
  }

  // MARK: - Functions
  init(row_id: Int? = nil,
       patient_id: Int,
       segment: Int,
       height: Double,
       weight: Double,
       date: Date! = nil,
       date_string: String! = nil,
       frequency: Double,
       impedances: [Impedance]) {

    date_format.dateFormat = "dd/MM/yy HH:mm" // FIXME: translation needed

    self.row_id = row_id
    self.patient_id = patient_id
    self.segment = segment
    self.height = height
    self.weight = weight
    self.frequency = frequency

    self.impedances = impedances

    if let d = date {
      self.date = d
    } else if let s = date_string {
      self.date = date_format.date(from: s)!
    } else {
      self.date = Date()
    }
  }

  fileprivate func patient() -> Patient {
    return dbSharedInstance.selectPatient(patient_id)
  }
}

func ==(lhs: Exam, rhs: Exam) -> Bool {
  return false //lhs.patient_id == rhs.patient_id && lhs.row_id == rhs.row_id
}

