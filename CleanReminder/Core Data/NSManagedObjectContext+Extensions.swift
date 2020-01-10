//
//  NSManagedObjectContext+Extensions.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 07.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {

    func tryPerform(action: @escaping (NSManagedObjectContext) throws -> Void) {
        self.performAndWait {
            do {
                try action(self)
            }
            catch let error as NSError {
                assertionFailure("Error catched: \(error), \(error.userInfo)")
            }
        }
    }

}
