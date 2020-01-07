//
//  SpotListViewController.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 01.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit
import CoreData

class SpotListViewController: UITableViewController {

    // MARK: - Properties

    private let cellID = "spotCell"

    private var context: NSManagedObjectContext!
    private var spots: [Spot] = .init()

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.context = CoreDataStack(modelName: "CleanReminder").context
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        let cellClassName = String(describing: SpotTableViewCell.self)
        let cellUINib = UINib(nibName: cellClassName, bundle: nil)
        self.tableView.register(cellUINib, forCellReuseIdentifier: self.cellID)

        fetchSpots()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spots.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as? SpotTableViewCell else {
            return UITableViewCell()
        }
        let spot = self.spots[indexPath.row]
        cell.titleLabel?.text = spot.name

        if let date = spot.lastActionDate {
            let dateStringRepresentation = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
            cell.subtitleLabel?.text = dateStringRepresentation
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.context.tryPerform {
                let spot = self.spots[indexPath.row]
                self.context.delete(spot)
                try? self.context.save()
                self.spots.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let spotDetailViewController: SpotDetailViewController

        switch segue.identifier {
        case "newSpot":
            guard let destinationNavigationController = segue.destination as? UINavigationController,
            let destinationViewController = destinationNavigationController.viewControllers.first as? SpotDetailViewController else {
                assertionFailure("Unexpected UI stack")
                return
            }

            destinationNavigationController.presentationController?.delegate = destinationViewController
            spotDetailViewController = destinationViewController
            spotDetailViewController.context = self.context
        case "showDetail":
            guard let viewController = segue.destination as? SpotDetailViewController else {
                assertionFailure("Unexpected UI stack")
                return
            }

            spotDetailViewController = viewController
            spotDetailViewController.context = self.context

            guard let selectedIndexPath = self.tableView.indexPathForSelectedRow,
                let spot = self.spots[safe: selectedIndexPath.row] else {
                    assertionFailure("Selected spot is expected")
                    return
            }

            spotDetailViewController.spot = spot

        default:
            assertionFailure("Unknown segue")
            return
        }
    }

    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard segue.identifier == "back",
            (segue.source as? SpotDetailViewController) != nil else {
                return
        }

        fetchSpots()
        self.tableView.reloadData()
    }

    // MARK: - Private

    private func fetchSpots() {
        self.context.tryPerform {
            let fetchRequest: NSFetchRequest<Spot> = Spot.fetchRequest()
            self.spots = try self.context.fetch(fetchRequest)
        }
    }

}
