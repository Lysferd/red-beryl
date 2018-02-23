//
//  MeasuresDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/16.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class MeasuresDataSource: NSObject {

  var measures: [Measure]

  init(_ measures: [Measure] = []) {
    self.measures = measures
  }

  func count() -> Int {
    return self.measures.count
  }

  func append(_ measure: Measure) -> Bool {
    measures.append(measure)
    return true
  }

}

extension MeasuresDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return measures.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MeasureCell.self)) as! MeasureCell
    let measure = measures[indexPath.row]
    cell.date = measure.getDateString()
    cell.frequency = measure.frequency
    cell.real = measure.real
    cell.imaginary = measure.imaginary
    return cell
  }

}
