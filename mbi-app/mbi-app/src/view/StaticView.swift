//
//  StaticView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/04/05.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class StaticView: UIViewController {

  @IBOutlet weak var table: StaticTableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    table.identifier = DefaultCell.self
    table.insert(row: "test0")
    table.insert(row: "test1")
    table.insert(row: "test2")
    table.insert(row: "test3")
    table.insert(row: "test4")
    table.insert(row: "test5")
    table.insert(row: "test6")
  }
  
}
