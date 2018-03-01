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

  // MARK: - Properties
  // SQLite3 Connection-related
  let db: Connection!
  let db_path: String

  // Database tables
  var patients: Table!
  var exams: Table!

  // Database Columns for PATIENT
  let id = Expression<Int64>("id")
  let record = Expression<String>("record")
  let first_name = Expression<String>("first_name")
  let middle_name = Expression<String>("middle_name")
  let last_name = Expression<String>("last_name")
  let personal_id = Expression<String>("personal_id")
  let birth_date = Expression<String>("birth_date")
  let phone_number = Expression<String>("phone_number")
  let email = Expression<String>("email")
  let address = Expression<String>("address")
  let city = Expression<String>("city")
  let state = Expression<String>("state")
  let country = Expression<String>("country")
  let blood_type = Expression<String>("blood_type")
  let risk_groups = Expression<String>("risk_groups")               // ?
  let regular_medication = Expression<String>("regular_medication") // ?
  let register_date = Expression<Date>("register_date")
  let update_date = Expression<Date>("update_date")
  let exam_ids = Expression<String>("exam_ids")

  // MARK: - Object Initialization
  init() {
    NSLog("[DATABASE] Initializing instance object.")

    db_path = try! FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent("red_beryl.sqlite").path
    db = try? Connection(db_path)

    createPatientsTable()
    createExamsTable()
  }

  // MARK: - Patients Table
  func selectPatients() -> [Patient] {
    var rows: [Patient] = []

    for row in try! db.prepare(patients) {
      NSLog("Read from table: %d\t%@\t%@", row[id], row[record], row[first_name])
      let ids: [Int]
      if row[exam_ids].count > 0 {
        ids = row[exam_ids].components(separatedBy: ",").map { Int($0)! }
      } else {
        ids = []
      }

      rows.append(Patient(record: row[record],
                          first_name: row[first_name],
                          middle_name: row[middle_name],
                          last_name: row[last_name],
                          personal_id: row[personal_id],
                          birth_date: row[birth_date],
                          phone_number: row[phone_number],
                          email: row[email],
                          address: row[address],
                          city: row[city],
                          state: row[state],
                          country: row[country],
                          blood_type: row[blood_type],
                          risk_groups: row[risk_groups],
                          regular_medication: row[regular_medication],
                          register_date: row[register_date],
                          update_date: row[update_date],
                          exam_ids: ids
        )
      )
    }

    return rows
  }

  func insertPatient(_ patient: Patient) {
    let insert = patients.insert(record <- patient.record,
                                 first_name <- patient.first_name,
                                 middle_name <- patient.middle_name,
                                 last_name <- patient.last_name)
    let rowid = try! db.run(insert)

    NSLog("Inserting %d\t%@\t%@", rowid, patient.record, patient.first_name)
  }

  func dropPatient(_ patient: Patient) {
    let row = patients.filter(record == patient.record)
    try! db.run(row.delete())
  }

  func dropAllPatients() {
    try! db.run(patients.delete())
  }

  fileprivate func createPatientsTable(overwrite: Bool = false) {
    patients = Table("patients")
    if overwrite { try! db.run(patients.drop(ifExists: true)) }

    try! db.run(patients.create(ifNotExists: true, block: { t in
      t.column(id, primaryKey: .autoincrement)
      t.column(record, unique: true, collate: .rtrim)
      t.column(first_name, defaultValue: "", collate: .rtrim)
      t.column(middle_name, defaultValue: "", collate: .rtrim)
      t.column(last_name, defaultValue: "", collate: .rtrim)
      t.column(personal_id, defaultValue: "", collate: .rtrim)
      t.column(birth_date, defaultValue: "", collate: .rtrim)
      t.column(phone_number, defaultValue: "", collate: .rtrim)
      t.column(email, defaultValue: "", collate: .nocase)
      t.column(address, defaultValue: "", collate: .rtrim)
      t.column(city, defaultValue: "", collate: .rtrim)
      t.column(state, defaultValue: "")
      t.column(country, defaultValue: "")
      t.column(blood_type, defaultValue: "")
      t.column(risk_groups, defaultValue: "")
      t.column(regular_medication, defaultValue: "")
      t.column(register_date, defaultValue: Date())
      t.column(update_date, defaultValue: Date())
      t.column(exam_ids, defaultValue: "")
    }))
  }

  // MARK: - Exams Table
  fileprivate func createExamsTable(overwrite: Bool = false) {
    exams = Table("exams")
    if overwrite { try! db.run(exams.drop(ifExists: true)) }

    try! db.run(exams.create(ifNotExists: true, block: { t in
      t.column(id, primaryKey: .autoincrement)
    }))
  }

}
