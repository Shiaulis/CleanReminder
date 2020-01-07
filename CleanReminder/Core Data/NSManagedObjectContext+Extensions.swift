//
//  NSManagedObjectContext+Extensions.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 07.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import CoreData

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
