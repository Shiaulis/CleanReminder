//
//  SpotDetailViewController.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 01.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit
import CoreData

class SpotDetailViewController: UITableViewController {

    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lastDateDetailLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var frequencyDetailLabel: UILabel!
    @IBOutlet weak var frequencyPicker: FrequencyPicker!

    // MARK: - Properties

    var spot: Spot?
    var context: NSManagedObjectContext!
    private var currentTextFieldTitle: String { self.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }


    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.textField.becomeFirstResponder()
        self.datePicker.maximumDate = Date()
        self.frequencyPicker.selectedBlock = { [weak self] selectedFrequency in
            self?.frequencyDetailLabel.text = selectedFrequency.title
        }

        if let spot = self.spot {
            setup(with: spot)
        }
        else {
            self.saveButtonItem.isEnabled = !self.currentTextFieldTitle.isEmpty
        }

        self.lastDateDetailLabel.text = string(describing: self.datePicker.date)
        self.frequencyDetailLabel.text = frequencyPicker.selectedFrequency.title
    }

    @IBAction func dateChanged(_ sender: UIDatePicker) {
        self.lastDateDetailLabel.text = string(describing: sender.date)
    }

    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        self.saveButtonItem.isEnabled = !self.currentTextFieldTitle.isEmpty
    }

    @IBAction func save(_ sender: UINavigationItem) {
        saveSpot()
        self.performSegue(withIdentifier: "back", sender: sender)
    }

    // MARK: - Private

    private func setup(with spot: Spot) {
        self.textField.text = spot.name
        self.datePicker.date = spot.lastActionDate ?? Date()
        self.frequencyPicker.select(frequency: spot.frequency, animated: false)
    }

    private func saveSpot() {
        let spot: Spot = self.spot ?? .init(context: self.context)
        spot.name = self.currentTextFieldTitle
        spot.lastActionDate = self.datePicker.date
        spot.frequency = self.frequencyPicker.selectedFrequency

        self.context.tryPerform {
            try self.context.save()
        }
    }

    private func string(describing date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
    }
}
