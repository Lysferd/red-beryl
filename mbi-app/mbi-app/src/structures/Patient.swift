//
//  Patient.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import CoreData
import UIKit

extension Patient {

  enum Section: Int {
    case personal, medical, exams, actions, count
  }

  struct Action {
    var caption: String
    var color: UIColor
  }

  //
  // * Ordered Array of Keys
  //
  var ordered_keys: Dictionary<Section, [Any]> {
    return [
      .personal: [
        "record",
        "firstName",
        "middleName",
        "lastName",
        "personalId",
        "phoneNumber",
        "email",
        "address",
        "city",
        "state",
        "country"
      ],

      .medical: [
        "birthDate",
        "gender",
        "bloodType",
        "ethnicity",
        "riskGroups",
        "regularMedications"
      ],

      .exams: [
        Array(self.exams!)
      ],

      .actions: [
        Action(caption: "deletePatient", color: UIColor.red)
      ]
    ]
  }

  //
  // * Unordered Array of Keys
  //
  var keys: [String] {
    return Array(self.entity.attributesByName.keys)
  }

  //
  // * Unordered Array of Values
  //
  var values: [NSAttributeDescription] {
    return Array(self.entity.attributesByName.values)
  }

  //
  // * Get Key/Value Pairs
  // bonus flavor: data["fullName"] = fullname
  //
  var pairs: Dictionary<String, Any> {
    return self.dictionaryWithValues(forKeys: self.keys)
  }

  //
  // * Helper Variables
  //
  var fullname: String {
    var name: String = ""
    if let first  = self.firstName  { name = first }
    if let middle = self.middleName { name += " " + middle }
    if let last   = self.lastName   { name += " " + last }
    return name
  }

  var section_count: Int {
    return Section.count.rawValue
  }

  //
  // * Helper Methods
  //
  func title(forSection section: Int) -> String {
    var key = ""
    switch Section(rawValue: section) {
    case .some(.personal):
      key = "personalInformation"
    case .some(.medical):
      key = "medicalInformation"
    case .some(.exams):
      key = "lastExams"
    case .some(.actions):
      key = "advancedOptions"
    default:
      break
    }

    return NSLocalizedString(key, comment: key)
  }

  func rows(forSection section: Int) -> [Any] {
    guard section < section_count else { fatalError() }

    if let s = Section(rawValue: section), let d = ordered_keys[s] {
      return d
    }

    return [] // return empty array for failproofness
  }

  func rowCount(forSection section: Int) -> Int {
    return rows(forSection: section).count
  }

  //
  // * Fill Data into Cell
  // Overloaded functions sensible to Cell context.
  func populateData(forCell cell: inout PatientDetailCell, atRow row: Int, inSection section: Int) {
    if let key = rows(forSection: section)[row] as? String {
      cell.title = NSLocalizedString(key, comment: key)
      if let value = pairs[key] as? String {
        cell.value = value
      }
    }
  }

  func populateData(forCell cell: inout ExamCell, atRow row: Int, inSectio section: Int) {
    if let set = self.exams, let exams = Array(set) as? [Exam] {
      if exams.isEmpty {
        cell.name = "No Exams"
      } else {
        cell.name = exams[row].segment
        cell.date = exams[row].date_string
        cell.reading = "\(exams[row].height) x \(exams[row].weight)"
      }
    }
  }

  func populateData(forCell cell: inout ActionCell, atRow row: Int, inSection section: Int) {
    if let actions_array = ordered_keys[.actions] as? [Action] {
      let i18n_caption = NSLocalizedString(actions_array[row].caption,
                                           comment: actions_array[row].caption)
      cell.caption = i18n_caption
      cell.color = actions_array[row].color
    }
  }

}
