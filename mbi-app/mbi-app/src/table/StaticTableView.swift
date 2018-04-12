//
//  StaticTableView.swift
//  mbi-app
//
//  Generates a static table with the given row data.
//  Sections are not functional yet.
//
//  Created by 埜原菽也 on H30/04/03.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class StaticTableView: UITableView {

  // - rows
  // Row data array.
  var rows: [Any] = []

  // - identifier
  // Class identifier to spawn TableCell.
  var identifier: Any?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    dataSource = self
  }

  //
  // - StaticTableView#insert(row:, at:)
  // Inserts the object into the rows array, then proceeds to add the
  // corresponding cell to the table. If at: argument is not given, the object
  // will be inserted at the end.
  //
  func insert(row r: Any, at i: Int = -1) {
    //try validate(index: i)

    var j = 0
    if i < 0 {
      j = rows.count + 1 + i
    } else {
      j = i
    }

    let index = IndexPath(row: j, section: 0)
    rows.insert(r, at: j)
    insertRows(at: [index], with: .automatic)
  }

  //
  // - StaticTableView#append(row:)
  // Same as #insert, but always appends to the end of array and table.
  //
  func append(row r: Any) {
    rows.append(r)
  }

  //
  // - StaticTableView#remove(at:)
  // Removes the element at the given index, then proceeds to remove the
  // corresponding cell from the table. Allows negative indexes for usability.
  //
  func remove(at i: Int) throws {
    try validate(index: i)

    var j = 0
    if i < 0 {
      j = rows.count + 1 + i
    } else {
      j = i
    }

    rows.remove(at: j)
    let index = IndexPath(row: j, section: 0)
    deleteRows(at: [index], with: .automatic)
  }

  //
  // #validate(index:)
  // Verifies that the given index can be used in this context.
  //
  fileprivate func validate(index i: Int) throws {
    guard i <= rows.count, i >= -rows.count else {
      throw ArgumentError.outOfRange(maxRange: rows.count)
    }
  }

  //
  // #convertIndex(_:)
  // Usability method for converting negative indexes.
  //
  fileprivate func convertIndex(_ i: Int) -> Int {
    if i < 0 { return rows.count + i + 1 }
    return i
  }

}

// Extend class to DataSource protocols:
extension StaticTableView: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let className = String(describing: UITableViewCell.self)
    let cell = dequeueReusableCell(withIdentifier: className) as! UITableViewCell

    return cell
  }

}
