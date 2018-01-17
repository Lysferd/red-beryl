//
//  mbi_appTests.swift
//  mbi-appTests
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import XCTest
@testable import mbi_app

class mbi_appTests: XCTestCase {
  
  // MARK: Patient Class Test
  func testPatientInitializationSucceeds() {
    let person = Patient.init(record: "837491", first_name: "Bolacha",
                              middle_name: "Com", last_name: "Biscoito")
    XCTAssertNotNil(person)
  }
  
  func testPatientInitializerFails() {
    let person = Patient.init(record: "", first_name: "", middle_name: "", last_name: "")
    XCTAssertNil(person)
  }
    
}
