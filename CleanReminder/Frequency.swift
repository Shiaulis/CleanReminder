//
//  Regularity.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 02.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum Frequency: Int16, CaseIterable {
    case none
    case daily
    case weekly
    case monthly
    case yearly

    var title: String {
        switch self {
        case .none: return "none"
        case .daily: return "daily"
        case .weekly: return "weekly"
        case .monthly: return "monthly"
        case .yearly: return "yearly"
        }
    }
}
