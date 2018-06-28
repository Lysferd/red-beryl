//
//  MeasuresDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/16.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import CoreData

class MeasuresDataSource: NSObject {

  fileprivate var measures: [Measure]
  public var selectedMeasure: IndexPath?

  override init() {
    measures = []
  }

  var count: Int! {
    get { return self.measures.count }
  }

  func append(_ measure: Measure) -> Bool {
    measures.append(measure)
    return true
  }

  func clear() {
    measures.removeAll()
  }

  subscript(index: Int) -> Measure {
    get { return measures[index] }
    set(obj) { measures.insert(obj, at: index) }
  }

  subscript(indexes: [Int]) -> [Measure] {
    get {
      var tmp: [Measure] = []
      for i in indexes { tmp.append(measures[i]) }
      return tmp
    }

    set(objs) {
      for i in indexes { measures[i] = objs[i] }
    }
  }

  subscript(index: IndexPath) -> Measure {
    get { return measures[index.item] }
    set(obj) { measures.insert(obj, at: index.item) }
  }

  subscript(indexes: [IndexPath]) -> [Measure] {
    get {
      var tmp: [Measure] = []
      for i in indexes { tmp.append(measures[i.item]) }
      return tmp
    }

    set(objs) {
      for i in indexes { measures[i.item] = objs[i.item] }
    }
  }

}

extension MeasuresDataSource: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return measures.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MeasureCell.self)) as! MeasureCell

    let measure = measures[indexPath.row]
    cell.date      = measure.date
    cell.frequency = measure.frequency
    cell.real      = measure.impedance.real
    cell.imaginary = measure.impedance.imaginary

    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Leituras disponíveis:" // FIXME: translation needed
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    if let cell = tableView.cellForRow(at: indexPath) {
      if selectedMeasure == indexPath {
        cell.accessoryType = .none
        selectedMeasure = nil
      } else {
        cell.accessoryType = .checkmark
        if let index = selectedMeasure,
          let old_cell = tableView.cellForRow(at: index) {
          old_cell.accessoryType = .none
        }
        selectedMeasure = indexPath
      }
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

}
