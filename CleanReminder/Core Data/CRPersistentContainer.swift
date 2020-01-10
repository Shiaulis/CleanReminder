//
//  CRPersistentContainer.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 10.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData

final class CRPersistentContainer: NSPersistentContainer {

    // MARK: - Loading store

    func startLoadPersistentStores(asynchronously: Bool, completion: @escaping (Result<CRPersistentContainer, Error>) -> Void) {
        let description = NSPersistentStoreDescription()
        description.shouldAddStoreAsynchronously = asynchronously
        self.persistentStoreDescriptions.append(description)
        super.loadPersistentStores { [weak self] (description, error) in
            if error != nil {
                completion(.failure(.unknown))
                return
            }

            guard let self = self else {
                completion(.failure(.unknown))
                return
            }

            completion(.success(self))
        }
    }

}

extension CRPersistentContainer {
    enum Error: Swift.Error {
        case unknown
    }
}
