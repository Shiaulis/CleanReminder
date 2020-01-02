//
//  NewSpotViewController.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 01.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit

class NewSpotViewController: UIViewController {

    @IBOutlet weak var spotNameTextField: UITextField!
    var spotName: String? {
        self.spotNameTextField.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.spotNameTextField.becomeFirstResponder()
    }

}
