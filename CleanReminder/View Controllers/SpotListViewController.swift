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
    private lazy var context: NSManagedObjectContext = {
        CoreDataStack(modelName: "CleanReminder").context
    }()

    private lazy var fetchController: NSFetchedResultsController<Spot> = {
        let fetchRequest: NSFetchRequest<Spot> = Spot.fetchRequest()
        let sort: NSSortDescriptor = .init(
            key: #keyPath(Spot.name),
            ascending: true
        )
        fetchRequest.sortDescriptors = [sort]

        let controller: NSFetchedResultsController = .init(
            fetchRequest: fetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        controller.delegate = self

        return controller
    }()

    private lazy var dataSource: SpotDiffableDataSource<Section, Spot> = {
        SpotDiffableDataSource<Section, Spot>.init(tableView: self.tableView) {
            [unowned self] (tableView, indexPath, spot) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
            self.configure(cell: cell, at: indexPath)

            return cell
        }
    }()

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        performInitialUIConfigure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.performWithoutAnimation {
            performInitialFetch()
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // FIXME: apply object deletion
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

            guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else {
                    assertionFailure("Selected cell is expected")
                    return
            }

            spotDetailViewController.spot = self.fetchController.object(at: selectedIndexPath)

        default:
            assertionFailure("Unknown segue")
            return
        }
    }

    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard segue.identifier == "back",
            (segue.source as? SpotDetailViewController) != nil else {
                assertionFailure("Unknown segue")
                return
        }
    }

    // MARK: - Private

    private func performInitialFetch() {
        self.context.tryPerform {
            try self.fetchController.performFetch()
        }
    }

    private func performInitialUIConfigure() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        let cellClassName: String = .init(describing: SpotTableViewCell.self)
        let cellUINib: UINib = .init(nibName: cellClassName, bundle: nil)
        self.tableView.register(cellUINib, forCellReuseIdentifier: self.cellID)
    }

    private func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SpotTableViewCell else {
            assertionFailure("Unknown cell class")
            return
        }

        let spot = self.fetchController.object(at: indexPath)
        cell.titleLabel?.text = spot.name

        if let date = spot.lastActionDate {
            let dateStringRepresentation = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
            cell.subtitleLabel?.text = dateStringRepresentation
        }
    }

}

extension SpotListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var diff = NSDiffableDataSourceSnapshot<Section, Spot>()
        diff.appendSections([.main])
        let spots = snapshot.itemIdentifiers.compactMap { id -> Spot? in
            guard let objectID = id as? NSManagedObjectID else { return nil }
            return controller.managedObjectContext.object(with: objectID) as? Spot
        }

        diff.appendItems(spots)

        self.dataSource.apply(diff)
    }
}

extension SpotListViewController {
    enum Section: CaseIterable {
        case main
    }
}

/**
 This class provides an ability to use native editing for table views
 */
private class SpotDiffableDataSource<T: Hashable, S: Hashable>: UITableViewDiffableDataSource<T, S> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

