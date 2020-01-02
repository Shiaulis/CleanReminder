//
//  NewSpotViewController.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 01.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit

class NewSpotViewController: UITableViewController {

    @IBOutlet weak var spotNameTextField: UITextField!
    @IBOutlet weak var lastDateDetailLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - Properties
    var spotName: String? { self.spotNameTextField.text }
    var lastActionDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.spotNameTextField.becomeFirstResponder()
        let today = Date()
        self.datePicker.maximumDate = today
        updateDateDetailLabel(with: today)
    }

    @IBAction func lastDateChanged(_ sender: UIDatePicker) {
        updateDateDetailLabel(with: sender.date)
    }

    private func updateDateDetailLabel(with date: Date) {
        let dateStringRepresentation = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
        self.lastDateDetailLabel.text = dateStringRepresentation

    }
}
