//
//  CoreDataStack.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 01.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {

    private let modelName: String
    private lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = .init(name: self.modelName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                assertionFailure()
            }
        }

        return container
    }()

    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }

    init(modelName: String) {
        self.modelName = modelName
    }
}
