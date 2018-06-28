//
//  EthnicityPicker.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/05/15.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class EthnicityPicker: UIPickerView, UIPickerViewDataSource {

  let choices = [ NSLocalizedString("asian", comment: "asian"),
                  NSLocalizedString("black", comment: "black"),
                  NSLocalizedString("caucasian", comment: "caucasian"),
                  NSLocalizedString("indigenous", comment: "indigenous"),
                  NSLocalizedString("mixedRace", comment: "mixedRace") ]

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    dataSource = self
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return choices.count + 1
  }

  func titleForRow(_ row: Int, forComponent component: Int) -> String? {
    return row == 0 ? NSLocalizedString("pickOption", comment: "Pick an option") : choices[row-1]
  }

}
