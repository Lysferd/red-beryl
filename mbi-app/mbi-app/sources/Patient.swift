//
//  Patient.swift
//  mbi-app
//
//  Created by 埜原菽也 on H29/10/18.
//  Copyright © 平成29年 M.A. Eng. All rights reserved.
//

import UIKit

class Patient {
  
  // MARK: Properties
  var name: String
  
  // MARK: Initialization
  init?(name: String) {
    if name.isEmpty {
      return nil
    }
    
    self.name = name
  }
  
}
