//
//  SelectMedicationsView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/05/22.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class SelectMedicationsView: UITableViewController {

  public var selection: [String]?
  var medications: [String]
  var selectedRows: [IndexPath] = []

  //
  required init?(coder aDecoder: NSCoder) {
    medications = [
      "Medicine A",
      "Medicne B"
    ]

    super.init(coder: aDecoder)
  }

  //
  override func viewDidLoad() {
    super.viewDidLoad()

    let nib = UINib(nibName: "BasicCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "BasicCell")

    if let selections = self.selection {
      for object in selections {
        if let row = medications.index(of: object) {
          selectedRows.append(IndexPath(row: row, section: 0))
        }
      }
    }
  }

  //
  override func viewWillDisappear(_ animated: Bool) {
    performSegue(withIdentifier: "back", sender: self)
  }

  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return medications.count
  }

  //
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
    cell.label = medications[indexPath.row]
    cell.accessoryType = selectedRows.contains(indexPath) ? .checkmark : .none

    return cell
  }

  //
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    if let cell = tableView.cellForRow(at: indexPath) {
      if selectedRows.contains(indexPath) {
        cell.accessoryType = .none
        if let i = selectedRows.index(of: indexPath) {
          selectedRows.remove(at: i)
        }
      } else {
        cell.accessoryType = .checkmark
        selectedRows.append(indexPath)
      }
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

  //
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    selection = selectedRows.map { medications[$0.row] }
  }

}
