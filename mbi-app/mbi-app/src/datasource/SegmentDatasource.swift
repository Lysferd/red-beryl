//
//  SegmentDatasource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/08.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class SegmentDataSource: NSObject {

}

extension SegmentDataSource: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Constants.segments.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SegmentCell.self)) as! SegmentCell
    //let exam = exams[indexPath.row]

    cell.name = Constants.segments[indexPath.row]
    return cell
  }

}
