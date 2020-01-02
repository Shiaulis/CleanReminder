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

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lastDateDetailLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - Properties

    var spot: Spot?
    var context: NSManagedObjectContext!

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.textField.becomeFirstResponder()
        self.datePicker.maximumDate = Date()

        if let spot = self.spot {
            setup(with: spot)
        }
    }

    @IBAction func save(_ sender: UINavigationItem) {
        saveSpot()
        self.performSegue(withIdentifier: "back", sender: sender)
    }


    // MARK: - Private

    private func setup(with spot: Spot) {
        self.textField.text = spot.name
        self.datePicker.date = spot.lastActionDate ?? Date()
    }

    private func saveSpot() {
        let spot: Spot = self.spot ?? Spot(context: self.context)
        spot.name = self.textField.text
        spot.lastActionDate = self.datePicker.date

        self.context.tryPerform {
            try self.context.save()
        }
    }
}
