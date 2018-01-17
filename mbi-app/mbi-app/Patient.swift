//
//  Patient.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit
//import os.log

class Patient {
  //: NSObject, NSCoding {
  
  // MARK: Properties
  /*
  struct PropertyKey {
    static let record = "record"
    static let first_name = "first_name"
    static let middle_name = "middle_name"
    static let last_name = "last_name"
    static let personal_id = "personal_id"
    static let birth_date = "birth_date"
    static let phone_number = "phone_number"
    static let email = "email"
    static let address = "address"
    static let city = "city"
    static let state = "state"
    static let country = "country"
    static let blood_type = "blood_type"
    static let risk_groups = "risk_groups"
    static let regular_medicines = "regular_medicines"
    static let register_date = "register_date"
    static let update_date = "update_date"
    static let last_consultation = "last_consultation"
  }
 */
  
  var record: String
  var first_name: String
  var middle_name: String
  var last_name: String
  
  // MARK: Initialization
  init?(record: String, first_name: String, middle_name: String, last_name: String) {
    guard !first_name.isEmpty else {
      return nil
    }
    
    self.record = record
    self.first_name = first_name
    self.middle_name = middle_name
    self.last_name = last_name
  }
  
  // MARK: NSCoding
  /*
  func encode(with aCoder: NSCoder) {
    aCoder.encode(record, forKey: PropertyKey.record)
    aCoder.encode(first_name, forKey: PropertyKey.first_name)
    aCoder.encode(last_name, forKey: PropertyKey.last_name)
  }
 */
  
}
