//
//  PatientDetailView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/01/12.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class PatientDetailView: UIViewController {

//  @IBOutlet weak var recordLabel: UILabel!
//  @IBOutlet weak var firstnameLabel: UILabel!
//  @IBOutlet weak var middlenameLabel: UILabel!
//  @IBOutlet weak var lastnameLabel: UILabel!

//  @IBOutlet weak var table: PatientDetailTable!

  var patient: Patient?
//  var datasource: PatientDetailDataSource

  required init?(coder aDecoder: NSCoder) {
//    datasource = PatientDetailDataSource()

    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

//    table.dataSource = datasource
  }

  // MARK: Private
  @IBAction func edit(_ sender: UIBarButtonItem) {
  }

  func dropPatient() {
    performSegue(withIdentifier: "deletePatientSegue", sender: self)
    navigationController?.popViewController(animated: true)
  }

  @IBAction func deleteClicked(_ sender: UIButton) {
    let title = "Atenção"
    let message = "A remoção de um paciente também remove todos os exames " +
    "relacionados ao paciente.\nDeseja apagar o paciente?"

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Apagar", style: .destructive) { (_) in self.dropPatient() })
    self.present(alert, animated: true, completion: nil)
  }

}
