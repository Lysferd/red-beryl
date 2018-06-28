//
//  SelectPatientView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/28.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import CoreData

class SelectPatientView: UIViewController {

  @IBOutlet weak var patientsTable: UITableView!
  fileprivate var patients: [Patient]
  var delegate: AppDelegate
  var context:  NSManagedObjectContext
  var selection: IndexPath?
  public var selectedPatient: Patient?

  required init?(coder aDecoder: NSCoder) {
    delegate = UIApplication.shared.delegate as! AppDelegate
    context = delegate.persistentContainer.viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Patient")
    request.returnsObjectsAsFaults = false

    do {
      let fetch = try context.fetch(request) as! [Patient]
      patients = fetch.sorted { $0.firstName! < $1.firstName! }

    } catch {
      fatalError(error.localizedDescription)
    }

    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    let nib = UINib(nibName: "BasicCell", bundle: nil)
    patientsTable.register(nib, forCellReuseIdentifier: "BasicCell")

    patientsTable.tableFooterView = UIView()
    patientsTable.dataSource = self
    patientsTable.delegate = self
    patientsTable.reloadData()

    super.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    performSegue(withIdentifier: "back", sender: self)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let index = selection {
      selectedPatient = patients[index.row]
    }
  }
}

extension SelectPatientView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return patients.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
    cell.label = patients[indexPath.row].fullname
    cell.accessoryType = selection == indexPath ? .checkmark : .none
    return cell
  }
}

extension SelectPatientView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let index = selection, let cell = tableView.cellForRow(at: index) {
      cell.accessoryType = .none
    }

    if let cell = tableView.cellForRow(at: indexPath) {
      cell.accessoryType = .checkmark
    }

    selection = indexPath
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
