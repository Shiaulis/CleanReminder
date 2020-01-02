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
    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - Properties
    var spotName: String? { self.spotNameTextField.text }
    var lastActionDate: Date? { self.datePicker.date }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.spotNameTextField.becomeFirstResponder()
        self.datePicker.maximumDate = Date()
    }

}
