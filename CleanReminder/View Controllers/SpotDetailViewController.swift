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
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lastDateDetailLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var frequencyDetailLabel: UILabel!
    @IBOutlet weak var frequencyPicker: FrequencyPicker!

    // MARK: - Properties

    var spot: Spot?
    var context: NSManagedObjectContext!
    private var currentTextFieldTitle: String { self.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
    private var hasChanges: Bool {
        let nameHasChanges = self.spot?.name?.trimmingCharacters(in: .whitespacesAndNewlines) != self.currentTextFieldTitle
        let dateHasChanges = self.spot?.lastActionDate != self.datePicker.date
        let frequencyHasChanges = self.spot?.frequency != self.frequencyPicker.selectedFrequency

        return nameHasChanges || dateHasChanges || frequencyHasChanges
    }

    private var canBeSaved: Bool { !self.currentTextFieldTitle.isEmpty }

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.datePicker.maximumDate = Date()
        self.frequencyPicker.selectedBlock = { [weak self] selectedFrequency in
            self?.frequencyDetailLabel.text = selectedFrequency.title
            self?.preventDismissIfNeeded()
        }

        if let spot = self.spot {
            setup(with: spot)
        }

        self.lastDateDetailLabel.text = string(describing: self.datePicker.date)
        self.frequencyDetailLabel.text = frequencyPicker.selectedFrequency.title

        self.presentationController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textField.becomeFirstResponder()
        preventDismissIfNeeded()
    }

    // MARK: - IBActions

    @IBAction func dateChanged(_ sender: UIDatePicker) {
        self.lastDateDetailLabel.text = string(describing: sender.date)
        preventDismissIfNeeded()
    }

    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        preventDismissIfNeeded()
    }

    @IBAction func saveTapped(_ sender: UINavigationItem) {
        performSave(sender: sender)
    }

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        if self.hasChanges {
            confirmCancel()
        }
        else {
            unwindBack(sender: sender)
        }
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

    private func preventDismissIfNeeded() {
        self.isModalInPresentation = self.hasChanges
        self.saveButtonItem.isEnabled = self.canBeSaved && self.hasChanges
    }

    private func string(describing date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
    }

    private func performSave(sender: Any?) {
        saveSpot()
        unwindBack(sender: sender)
    }

    private func unwindBack(sender: Any? = nil) {
        self.performSegue(withIdentifier: "back", sender: sender)
    }

    func confirmCancel() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if self.canBeSaved {
            alert.addAction(.init(title: "Save", style: .default) { action in
                self.performSave(sender: action)
            })
        }

        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive) { action in
            self.unwindBack(sender: action)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.barButtonItem = self.cancelButtonItem

        present(alert, animated: true, completion: nil)
    }
}

extension SpotDetailViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        confirmCancel()
    }

}
