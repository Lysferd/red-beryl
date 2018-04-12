//
//  PatientDetailTable.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/28.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientDetailTable: StaticTableView {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let className = String(describing: PatientDetailCell.self)
    let cell = dequeueReusableCell(withIdentifier: className) as! PatientDetailCell

    cell.title = String(describing: rows[indexPath.row])
    return cell
  }
}
