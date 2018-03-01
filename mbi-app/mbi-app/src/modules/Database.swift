//
//  Database.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/28.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation
import SQLite

let dbSharedInstance = Database()

class Database {

  // MARK - Properties
  // SQLite3 Connection-related
  let db: Connection!
  let db_path: String

  // Database tables
  var patients: Table!
  var exams: Table?

  // Database Columns
  let id = Expression<Int64>("id")
  let record = Expression<String>("record")
  let first_name = Expression<String>("first_name")

  init() {
    NSLog("[DATABASE] Initializing instance object.")

    db_path = try! FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent("red_beryl.sqlite").path
    db = try? Connection(db_path)

    createPatientsTable()
    //exams = Table("exams")
  }

  func selectPatients() -> [Patient] {
    var rows: [Patient] = []

    for row in try! db.prepare(patients) {
      NSLog("Read from table: %d\t%@\t%@", row[id], row[record], row[first_name])
      rows.append(Patient(record: row[record],
                          first_name: row[first_name],
                          middle_name: "",
                          last_name: ""))
    }

    return rows
  }

  func insertPatient(_ patient: Patient) {
    let insert = patients.insert(record <- patient.record, first_name <- patient.first_name)
    let rowid = try! db.run(insert)

    NSLog("Inserting %d\t%@\t%@", rowid, patient.record, patient.first_name)
  }

  fileprivate func createPatientsTable(overwrite: Bool = false) {
    patients = Table("patients")

    try! db.run(patients.create(ifNotExists: true, block: { t in
      t.column(id, primaryKey: .autoincrement)
      t.column(record, unique: true)
      t.column(first_name)
    }))
  }

  fileprivate func destroyPatientsTable() {
    try! db.run(patients.drop(ifExists: true))
  }

}
