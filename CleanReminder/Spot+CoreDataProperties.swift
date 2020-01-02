//
//  Spot+CoreDataProperties.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 02.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension Spot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spot> {
        return NSFetchRequest<Spot>(entityName: "Spot")
    }

    @NSManaged public var name: String?
    @NSManaged public var lastActionDate: Date?

}
