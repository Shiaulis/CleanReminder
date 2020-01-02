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

    private var coreDataStack: CoreDataStack!
    private var spots: [Spot] = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.coreDataStack = CoreDataStack(modelName: "CleanReminder")
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
        // #warning Incomplete implementation, return the number of rows
        return self.spots.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spotCell", for: indexPath)
        let spot = self.spots[indexPath.row]
        cell.textLabel?.text = spot.name

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let spot = self.spots[indexPath.row]
            self.coreDataStack.context.delete(spot)
            try? self.coreDataStack.context.save()
            self.spots.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard segue.identifier == "save",
            let sourceViewController = segue.source as? NewSpotViewController,
            let spotName = sourceViewController.spotName else { return }

        saveSpot(with: spotName)
        self.tableView.reloadData()
    }

    // MARK: - Private

    private func fetchSpots() {
        let fetchRequest: NSFetchRequest<Spot> = Spot.fetchRequest()

        do {
            self.spots = try self.coreDataStack.context.fetch(fetchRequest)
        }
        catch {
            assertionFailure()
        }
    }

    private func saveSpot(with name: String) {
        let spot = Spot(context: self.coreDataStack.context)
        spot.name = name
        self.spots.append(spot)

        do {
            try self.coreDataStack.context.save()
        }
        catch {
            assertionFailure()
        }
    }

}
