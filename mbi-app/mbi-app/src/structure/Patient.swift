//
//  Patient.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit

class Patient {
  var record: String
  var first_name: String
  var middle_name: String
  var last_name: String

  var personal_id: String
  var birth_date: String
  var phone_number: String
  var email: String
  var address: String
  var city: String
  var state: String
  var country: String

  var blood_type: String
  var risk_groups: String
  var regular_medication: String

  var register_date: String
  var update_date: String

  var exams: [Exam]

  init(record: String, first_name: String, middle_name: String,
       last_name: String, personal_id: String = "", birth_date: String = "",
       phone_number: String = "", email: String = "", address: String = "",
       city: String = "", state: String = "", country: String = "",
       blood_type: String = "", risk_groups: String = "",
       regular_medication: String = "",
       exams: [Exam] = []) {
    self.record = record
    self.first_name = first_name
    self.middle_name = middle_name
    self.last_name = last_name
    self.personal_id = personal_id
    self.birth_date = birth_date
    self.phone_number = phone_number
    self.email = email
    self.address = address
    self.city = city
    self.state = state
    self.country = country
    self.blood_type = blood_type
    self.risk_groups = risk_groups
    self.regular_medication = regular_medication
    self.register_date = ""
    self.update_date = ""
    self.exams = exams
  }

}

func ==(lhs: Patient, rhs: Patient) -> Bool {
  return lhs.record == rhs.record
}
