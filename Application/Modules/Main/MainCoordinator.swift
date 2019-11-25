//
//  MainCoordinator.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import UIKit

final class MainCoordinator: CoordinatorProtocol {
   
    typealias RootController = UINavigationController
    
    let rootController: UINavigationController
    let useCases: UseCasesProvider
    
    init(rootController: UINavigationController, useCases: UseCasesProvider) {
        self.rootController = rootController
        self.useCases = useCases
    }
    
    func start() {
        startMain()
    }
    
    // MARK: - Private
    
    private func startMain() {
        fatalError("You should implement UI integration. ViewModel + ViewController")
    }
}
