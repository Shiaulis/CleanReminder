//
//  Spot+CoreDataClass.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 01.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Spot)
public class Spot: NSManagedObject {

    var frequency: Frequency? {
        get {
            Frequency(frequencyDictionary: self.frequencyDictionary)
        }
        set {
            self.frequencyDictionary = newValue?.frequencyDictionary
        }
    }

}
