//
//  Exam.swift
//  mbi-app
//
//  Exam represents a complete bioimpedance exam with patient relationship,
//  body segment, patient's height and weight, date, frequency and
//  an array of impedance data.
//
//  Created by 埜原菽也 on H30/01/30.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import CoreData
import UIKit
import Darwin

extension Exam {


  fileprivate var formatter: DateFormatter! {
    let date_formatter = DateFormatter()
    date_formatter.dateFormat = "dd/MM/yy"
    return date_formatter
  }

  var date_string: String! {
    return formatter.string(from: self.date!)
  }

  var gender: Double! {
    return patient?.gender == "male" ? 1 : 0
  }

  var birthdate: Date! {
    if let p = patient, let date = p.birthDate {
      return formatter.date(from: date)
    }
    return Date()
  }

  var birthyear: Int! {
    return Calendar.current.component(.year, from: birthdate)
  }

  var age: Double! {
    return Double(Calendar.current.component(.year, from: Date()) - birthyear)
  }

  var impedances_array: [Impedance]! {
    return impedances?.allObjects as! [Impedance]
  }

  var resistance: Double! {
    return impedances_array[0].cimpedance
  }

  var tbw: Double! {
    let p1 = 0.372 * height * resistance
    let p2 = 3.05 * gender
    let p3 = 0.142 * weight
    let p4 = 0.004 * age

    return p1 + p2 + p3 - p4
  }

  var ffm: Double! {
    return tbw / 0.73
  }

  var fm: Double! {
    return weight - ffm
  }

  var bodyfat: Double! {
    return fm * 100 / weight
  }

}

/*

import Foundation

class Exam {
  
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
  var patient: Patient {
    do {
      return dbSharedInstance.selectPatient(patient_id)
    }
    catch {
      fatalError("Could not find patient with rowid \(patient_id).")
    }
  }

  var patient_name: String {
    return self.patient.full_name
  }

  var date_string: String {
    return date_format.string(from: date)
  }

  var segment_string: String {
    return Constants.segments[segment]
  }

  var impedance_string: String {
    let real = impedances[0].real / 1e3
    let imag = -impedances[0].imaginary / 1e3
    return String(format: "%.3f - j%.3f KΩ", real, imag)
  }

  var frequency_string: String! {
    get {
      let freq = frequency / 1e3
      return String(format: "%.f KHz", freq)
    }
  }

  var corrected_impedances: [Impedance]! {
    get {
      var result: [Impedance] = []
      for i in impedances {
        result.append(Impedance(real: i.real / height, imaginary: i.imaginary / height))
      }
      return result
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

}

func ==(lhs: Exam, rhs: Exam) -> Bool {
  return false //lhs.patient_id == rhs.patient_id && lhs.row_id == rhs.row_id
}

*/
