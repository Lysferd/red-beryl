//
//  NewExamView.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/02/15.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class NewExamView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

  @IBAction func detailClicked() {
    
  }

  @IBAction func cancelClicked(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

}
