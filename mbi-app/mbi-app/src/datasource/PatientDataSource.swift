//
//  PatientsDataSource.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import CoreData

                    //key    value
let example_data: [Dictionary<String, String>] = [

    [ // personal
      "record": "Y-104",
      "firstName": "Sir",
      "middleName": "Isaac",
      "lastName": "Newton",
      "personalId": "918-183-682",
      "address": "St. Somewhere 123A",
      "city": "Kensington",
      "state": "Middlesex",
      "country": "England",
      "email": "newton.isaac@bigmail.com",
      "phoneNumber": "1920386910",

      // medical
      "birthDate": "25/12/1642",
      "gender": "male",
      "bloodType": "a+",
      "ethnicity": "caucasiano",
      "riskGroups": "diabetes,",
      "regularMedications": "insulina" ],

    [ // personal
      "record": "Z-478",
      "firstName": "Carl",
      "middleName": "Friedrich",
      "lastName": "Gauß",
      "personalId": "928-182-268",
      "address": "Kingdom of Hanover",
      "city": "Brunswick",
      "state": "Principality of Brunswick-Wolfenbüttel",
      "country": "Holy Roman Empire",
      "email": "friedrich.gauss@littlemail.org",
      "phoneNumber": "1929038913",

      // medical
      "birthDate": "30/04/1777",
      "gender": "male",
      "bloodType": "o-",
      "ethnicity": "asiático",
      "riskGroups": "hipertensão",
      "regularMedications": "soro" ]
  ]

class PatientsDataSource: NSObject {

  var patients: Dictionary<Character, [Patient]>
  var sections: [Character]
  var delegate: AppDelegate
  var context:  NSManagedObjectContext

  //
  // *
  //
  override init() {
    delegate = UIApplication.shared.delegate as! AppDelegate
    context = delegate.persistentContainer.viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Patient")
    request.returnsObjectsAsFaults = false

    do {
      let fetch = try context.fetch(request) as! [Patient]
      let sorted = fetch.sorted { $0.firstName! < $1.firstName! }
      sections = Array(Set(sorted.map({($0.firstName?.first)!}))).sorted { $0 < $1 }

      patients = [:]
      for c in sections {
        patients[c] = fetch.filter { $0.firstName!.first == c }
      }

    } catch {
      fatalError(error.localizedDescription)
    }
  }

  //
  // *
  //
  func append(_ pairs: Dictionary<String, Any>) {
    let entity = NSEntityDescription.entity(forEntityName: "Patient", in: context)
    let new_entity = NSManagedObject(entity: entity!, insertInto: context)
    new_entity.setValuesForKeys(pairs)

//    for (key, value) in pairs { new_entity.setValue(value, forKey: key) }

    do {
      try context.save()
      reload()
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  //
  // *
  //
  func drop(_ patient: Patient) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Patient")
    request.predicate = NSPredicate(format: "record = %@", patient.record!)
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

  //
  // *
  //
  func reload() {
    patients.removeAll(keepingCapacity: true)
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Patient")
    request.returnsObjectsAsFaults = false

    do {
      let fetch = (try context.fetch(request) as! [Patient]).sorted { $0.firstName! < $1.firstName! }
      sections = Array(Set(fetch.map({($0.firstName?.first)!}))).sorted { $0 < $1 }

      for c in sections {
        patients[c] = fetch.filter { $0.firstName!.first == c }
      }

    } catch {
      fatalError(error.localizedDescription)
    }
  }

//  subscript(index: Int) -> Patient {
//    get { return patients[index] }
//    set(obj) { patients.insert(obj, at: index) }
//  }
//
//  subscript(index: IndexPath) -> Patient {
//    get { return patients[index.item] }
//    set(obj) { patients.insert(obj, at: index.item) }
//  }

}

extension PatientsDataSource: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return sections.map { String($0) }
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return String(sections[section])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if patients.count == 0 {
      let emptyLabel = UILabel()
      emptyLabel.numberOfLines = 0
      emptyLabel.font = UIFont.systemFont(ofSize: 14)
      emptyLabel.text = "Não há pacientes cadastrados.\nToque “+” para cadastrar um novo paciente." // FIXME: translation needed
      emptyLabel.textAlignment = .center
      tableView.backgroundView = emptyLabel
      tableView.separatorStyle = .none
    } else {
      tableView.separatorStyle = .singleLine
      tableView.backgroundView = nil
    }

    let key = sections[section]
    if let filter = patients[key] {
      return filter.count
    }

    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell") as! PatientCell

    var patient: Patient
    let key = sections[indexPath.section]
    if let filter = patients[key] {
      patient = filter[indexPath.row]
      cell.name = patient.fullname
    }

    return cell
  }
}
