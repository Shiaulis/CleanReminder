//
//  Regularity.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 02.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum Frequency {
    case daily(periodDistance: Int)
    case weekly(periodDistance: Int, weekdayNumbers: Set<Int>)
    case monthly(periodDistance: Int, monthDayNumbers: Set<Int>)
    case yearly(periodDistance: Int, monthNumbers: Set<Int>)

    init?(frequencyDictionary: NSObject?) {
        guard let frequencyDictionary = frequencyDictionary as? [String: Any],
            let typeNumber = frequencyDictionary["typeNumber"] as? Int,
            let periodDistance = frequencyDictionary["periodDistance"] as? Int else {
            return nil
        }

        let elementNumbers = frequencyDictionary["elementNumbers"] as? Set<Int> ?? []

        switch typeNumber {
        case 0: self = .daily(periodDistance: periodDistance)
        case 1: self = .weekly(periodDistance: periodDistance, weekdayNumbers: elementNumbers)
        case 2: self = .monthly(periodDistance: periodDistance, monthDayNumbers: elementNumbers)
        case 3: self = .yearly(periodDistance: periodDistance, monthNumbers: elementNumbers)
        default: return nil
        }
    }

    var frequencyDictionary: NSObject? {
        let typeNumber: Int
        let periodDistance: Int
        let elementNumbers: Set<Int>
        switch self {
        case .daily(let distance):
            typeNumber = 0
            periodDistance = distance
            elementNumbers = []
        case .weekly(let distance, let weekdayNumbers):
            typeNumber = 1
            periodDistance = distance
            elementNumbers = weekdayNumbers
        case .monthly(let distance, let monthDayNumbers):
            typeNumber = 2
            periodDistance = distance
            elementNumbers = monthDayNumbers
        case .yearly(let distance, let monthNumbers):
            typeNumber = 3
            periodDistance = distance
            elementNumbers = monthNumbers
        }

        return [
            "typeNumber": typeNumber,
            "periodDistance": periodDistance,
            "elementNumbers": elementNumbers
        ] as NSObject
    }
}
