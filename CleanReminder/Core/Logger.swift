//
//  Logger.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 11.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import os.log

enum LogSystem {
    case persistence
}

private extension LogSystem {
    func osLog(for appIdentifier: String) -> OSLog {
        OSLog(subsystem: appIdentifier, category: self.category)
    }

    private var category: String {
        switch self {
        case .persistence: return "persistence"
        }
    }
}

final class Logger {

    // MARK: - Properties

    private let appIdentifier: String
    // MARK: - Init

    init(appIdentifier: String) {
        self.appIdentifier = appIdentifier
    }

    func log(_ error: Error, logSystem: LogSystem) {
        os_log(.error, log: system(for: logSystem) , "%@", error.localizedDescription)
        assertionFailure("Error detected: \(error.localizedDescription)")
    }

    private func system(for logSystem: LogSystem) -> OSLog {
        logSystem.osLog(for: self.appIdentifier)
    }
}
