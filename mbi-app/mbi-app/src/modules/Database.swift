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
  let id = Expression<Int>("id")
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

  // Database Columns for EXAM
  //let id = Expression<Int>("id")
  let patient_id = Expression<Int>("patient_id") // reference back to patient table
  let segment = Expression<Int>("segment")
  let height = Expression<Double>("height")
  let weight = Expression<Double>("weight")
  let date = Expression<Date>("date")
  let frequency = Expression<Double>("frequency")

  let r_values = Expression<String>("r_values")
  let j_values = Expression<String>("j_values")

  let real = Expression<Double>("real")
  let imaginary = Expression<Double>("imaginary")


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
    }))
  }

  func selectPatient(_ index: Int) -> Patient {
    var patient: Patient?

    for row in try! db.prepare(patients.filter(id == index)) {
      patient = Patient(id: row[id],
                        record: row[record],
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
                        update_date: row[update_date]
      )
    }

    guard patient != nil else { fatalError("No patient exists with ID \(index)") }
    return patient!
  }

  func selectPatients() -> [Patient] {
    var rows: [Patient] = []

    for row in try! db.prepare(patients) {
      rows.append(Patient(id: row[id],
                          record: row[record],
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
                          update_date: row[update_date]
        )
      )
    }

    return rows
  }

  func insertPatient(_ patient: Patient) -> Int {
    let insert = patients.insert(record <- patient.record,
                                 first_name <- patient.first_name,
                                 middle_name <- patient.middle_name,
                                 last_name <- patient.last_name)
    let rowid = try! db.run(insert)

    NSLog("Inserting %d\t%@\t%@", rowid, patient.record, patient.first_name)

    return Int(rowid)
  }

  func dropPatient(_ patient: Patient) {
    let row = patients.filter(id == patient.row_id)
    try! db.run(row.delete())
  }

  func dropAllPatients() {
    try! db.run(patients.delete())
  }

  // MARK: - Exams Table
  fileprivate func createExamsTable(overwrite: Bool = false) {
    exams = Table("exams")
    if overwrite { try! db.run(exams.drop(ifExists: true)) }

    try! db.run(exams.create(ifNotExists: true, block: { t in
      t.column(id, primaryKey: .autoincrement)
      t.column(patient_id, references: patients, id)
      t.column(segment)
      t.column(height)
      t.column(weight)
      t.column(date)
      t.column(frequency)
      t.column(r_values)
      t.column(j_values)
    }))
  }

  func selectExams() -> [Exam] {
    var rows: [Exam] = []

    for row in try! db.prepare(exams) {
      var impedances: [Impedance] = []
      let r_str = row[r_values].split(separator: "|")
      let j_str = row[j_values].split(separator: "|")
      for i in 0..<r_str.count {
        if let r = Double(r_str[i]), let j = Double(j_str[i]) {
          impedances.append(Impedance(real: r, imaginary: j))
        }
      }


      rows.append(
        Exam(
          row_id: row[id],
          patient_id: row[patient_id],
          segment: row[segment],
          height: row[height],
          weight: row[weight],
          date: row[date],
          frequency: row[frequency],
          impedances: impedances
        )
      )
    }

    return rows
  }

  func insertExam(_ exam: Exam) -> Int {
    var r_string = ""
    var j_string = ""
    for i in 0..<exam.impedances.count {
      r_string.append(String(exam.impedances[i].real))
      j_string.append(String(exam.impedances[i].imaginary))

      if i < exam.impedances.count-1 {
        r_string.append("|")
        j_string.append("|")
      }
    }

    let insert = exams.insert(patient_id <- exam.patient_id,
                              segment <- exam.segment,
                              height <- exam.height,
                              weight <- exam.weight,
                              frequency <- exam.frequency,
                              date <- exam.date,
                              r_values <- r_string,
                              j_values <- j_string)

    let rowid = try! db.run(insert)

    NSLog("Inserting %d\t%d\t%d", rowid, exam.patient_id)

    return Int(rowid)
  }

  func dropExam(_ exam: Exam) {
    if let row_id = exam.row_id {
      let row = exams.filter(id == row_id)
      try! db.run(row.delete())
    }
  }

  func dropAllExams() {
    try! db.run(exams.delete())
  }

}
