//
//  RootViewController.swift
//  CleanReminder
//
//  Created by Andrius Shiaulis on 10.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    // MARK: - Properties
    
    private let persistentContainer: CRPersistentContainer
    private var childViewController: UIViewController? {
        didSet {
            guard let childViewController = self.childViewController else {
                remove()
                return
            }

            add(childViewController)
            let view: UIView! = childViewController.view

            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }
    }

    private lazy var spotListViewController: SpotListViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewControllerIdentifier = String(describing: SpotListViewController.self)

        return storyboard.instantiateViewController(identifier: viewControllerIdentifier) { coder in
            SpotListViewController.init(
                persistentContainer: self.persistentContainer,
                coder: coder
            )
        }
    }()

    // MARK: - Initialization

    init(persistentContainer: CRPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)

        layoutInitialViewStack()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController life cycle

    // MARK: - Private

    private func layoutInitialViewStack() {
        self.view.backgroundColor = .orange
        let navigationViewController = UINavigationController(rootViewController: self.spotListViewController)

        self.childViewController = navigationViewController
    }

    private func handle(_ error: Error) {

    }
}
