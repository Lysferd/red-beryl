//
//  SelectSegmentView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/08.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class SelectSegmentView: UIViewController {

  @IBOutlet weak var segmentsTable: UITableView!
  let datasource: SegmentDataSource
  public var selection: Int?

  required init?(coder aDecoder: NSCoder) {
    datasource = SegmentDataSource()

    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    segmentsTable.dataSource = datasource
    segmentsTable.reloadData()

    super.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    performSegue(withIdentifier: "back", sender: self)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let index = segmentsTable.indexPathForSelectedRow {
      selection = index.row
    }
  }

}
