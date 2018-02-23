//
//  ExamsDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/30.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class ExamsDataSource: NSObject {

  var exams: [Exam]

  init(_ exams: [Exam] = []) {
    self.exams = exams
  }

  func append(_ exam: Exam) -> Bool {
    //if exams.contains(where: { $0 == exam }) { return false }
    exams.append(exam)
    return true
  }
}

extension ExamsDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if exams.count == 0 {
      let emptyLabel = UILabel()
      emptyLabel.numberOfLines = 0
      emptyLabel.font = UIFont.systemFont(ofSize: 14)
      emptyLabel.text = "Não há exames no histórico.\nToque “+” para gerar um novo exame."
      emptyLabel.textAlignment = .center
      tableView.backgroundView = emptyLabel
      tableView.separatorStyle = .none
    } else {
      tableView.separatorStyle = .singleLine
      tableView.backgroundView = nil
    }

    return exams.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExamCell.self)) as! ExamCell
    //let exam = exams[indexPath.row]

    cell.name = "Person A"
    return cell
  }
}
