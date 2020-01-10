//
//  AppModel.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 10.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import os.log

final class AppModel {

    // MARK: - Properties

    static let shared = AppModel()

    // MARK: - Initialization

    let persistentContainer: CRPersistentContainer
    let logger: Logger

    init() {
        self.persistentContainer = .init(name: "CleanReminder")
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        self.logger = Logger(appIdentifier: bundleIdentifier)
        setupServices()
    }

    // MARK: - Private

    private func setupServices() {
        self.persistentContainer.startLoadPersistentStores(asynchronously: false) { result in
            switch result {
            case .success: break
            case .failure(let error):
                self.logger.log(error, logSystem: .persistence)
            }
        }
    }
}
