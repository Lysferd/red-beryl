//
//  ExamsDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/30.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import CoreData

class ExamsDataSource: NSObject {

  var exams: [Exam]
  var delegate: AppDelegate
  var context: NSManagedObjectContext

  override init() {
    delegate = UIApplication.shared.delegate as! AppDelegate
    context = delegate.persistentContainer.viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exam")
    request.returnsObjectsAsFaults = false

    exams = []
    do {
      if let fetch = try context.fetch(request) as? [Exam] {
        exams = fetch

        if let impedances = fetch.first?.impedances?.allObjects as? [Impedance] {
          print(impedances)
        }
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func append(_ data: Dictionary<String, Any>) {
    if let exam_entity = NSEntityDescription.entity(forEntityName: "Exam", in: context) {
      let new_exam = NSManagedObject(entity: exam_entity, insertInto: context)
      var d = data
      d.removeValue(forKey: "impedances")
      new_exam.setValuesForKeys(d)

      // Save Impedances
      if let impedance_data = data["impedances"] as? [(real: Double, imaginary: Double)] {
        if let impedance_entity = NSEntityDescription.entity(forEntityName: "Impedance", in: context) {
          for data in impedance_data {
            let new_impedance = NSManagedObject(entity: impedance_entity, insertInto: context)
            new_impedance.setValue(data.real, forKey: "real")
            new_impedance.setValue(data.imaginary, forKey: "imaginary")
            new_impedance.setValue(new_exam, forKey: "exam")
          }
        }
      }

      if context.hasChanges {
        do {
          try context.save()
          reload()
        } catch {
          fatalError(error.localizedDescription)
        }
      }
    }
  }

  func drop(_ exam: Exam) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exam")
    request.predicate = NSPredicate(format: "date = %@", exam.date! as CVarArg)
    request.returnsObjectsAsFaults = false

    do {
      let objs = try context.fetch(request)
      for obj in objs as! [NSManagedObject] { context.delete(obj) }
      try context.save()
      reload()
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func reset() {
    for exam in exams {
      drop(exam)
    }
  }

  func reload() {
    exams.removeAll(keepingCapacity: true)
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exam")
    request.returnsObjectsAsFaults = false

    do {
      if let fetch = try context.fetch(request) as? [Exam] {
        exams = fetch
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }

}

extension ExamsDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if exams.count == 0 {
      let emptyLabel = UILabel()
      emptyLabel.numberOfLines = 0
      emptyLabel.font = UIFont.systemFont(ofSize: 14)
      emptyLabel.text = "Não há exames no histórico.\nToque “+” para gerar um novo exame." // FIXME: translation needed
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
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "ExamCell")) as! ExamCell
    let exam = exams[indexPath.row]

    cell.name = exam.patient?.fullname
    cell.reading = "\(exam.height) / \(exam.weight)"
    cell.date = exam.date_string

    return cell
  }
}
