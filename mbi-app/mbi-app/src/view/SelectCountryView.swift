//
//  SelectCountryView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/05/02.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class SelectCountryView: UITableViewController {

  //
  // *
  //
  public var selection: String?
  var countries: [String]
  var lastSelection: IndexPath?

  //
  // *
  //
  required init?(coder aDecoder: NSCoder) {
    countries = NSLocale.isoCountryCodes.sorted {
      let c1 = NSLocale.current.localizedString(forRegionCode: $0)!
      let c2 = NSLocale.current.localizedString(forRegionCode: $1)!
      return c1 < c2
    }

    super.init(coder: aDecoder)
  }

  //
  // *
  //
  override func viewDidLoad() {
    super.viewDidLoad()

    let nib = UINib(nibName: "BasicCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "BasicCell")

    if let selected = self.selection, let row = countries.index(of: selected) {
      lastSelection = IndexPath(row: row, section: 0)
      tableView.scrollToRow(at: lastSelection!, at: .middle, animated: false)
    }
  }

  //
  // *
  //
  override func viewWillDisappear(_ animated: Bool) {
    performSegue(withIdentifier: "back", sender: self)
  }

  //
  // MARK: - Table view data source
  //
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }

  //
  // *
  //
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
    cell.accessoryType = indexPath == lastSelection ? .checkmark : .none

    let code = countries[indexPath.row]
    cell.label = "\(flag(forCountry: code)) \(name(forCountry: code))"

    return cell
  }

  //
  // *
  //
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let selection = lastSelection,
      let cell = tableView.cellForRow(at: selection) {
      cell.accessoryType = .none
    }

    if let cell = tableView.cellForRow(at: indexPath) {
      cell.accessoryType = .checkmark
    }

    lastSelection = indexPath
    tableView.deselectRow(at: indexPath, animated: true)
  }

  //
  // MARK: - Navigation
  //
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let last_selection = lastSelection {
      selection = countries[last_selection.row]
    }
  }

  //
  fileprivate func flag(forCountry code: String) -> String {
    let base: UInt32 = 127397
    var s = ""

    for v in code.unicodeScalars {
      s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }

    return String(s)
  }

  //
  fileprivate func name(forCountry code: String) -> String {
    return NSLocale.current.localizedString(forRegionCode: code)!
  }

}
