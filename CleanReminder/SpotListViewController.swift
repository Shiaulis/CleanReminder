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

    private var context: NSManagedObjectContext!
    private var spots: [Spot] = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.context = CoreDataStack(modelName: "CleanReminder").context
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        fetchSpots()
    }

    @IBAction func addSpotTapped(_ sender: UIBarButtonItem) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "spotCell", for: indexPath)
        let spot = self.spots[indexPath.row]
        cell.textLabel?.text = spot.name

        if let date = spot.lastActionDate {
            let dateStringRepresentation = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
            cell.detailTextLabel?.text = dateStringRepresentation
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Override to support editing the table view.
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
            guard let destination = segue.destination as? UINavigationController,
            let viewController = destination.viewControllers.first as? SpotDetailViewController else {
                assertionFailure("Unexpected UI stack")
                return
            }

            spotDetailViewController = viewController
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

private extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension NSManagedObjectContext {
    func tryPerform(action: @escaping () throws -> Void) {
        self.performAndWait {
            do {
                try action()
            }
            catch let error as NSError {
                assertionFailure("Error catched: \(error), \(error.userInfo)")
            }
        }
    }
}
