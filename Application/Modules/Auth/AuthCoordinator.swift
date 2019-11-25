//
//  AuthCoordinator.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import UIKit

final class AuthCoordinator: CoordinatorProtocol {
   
    typealias RootController = UINavigationController
    
    let rootController: UINavigationController
    let useCases: UseCasesProvider
    
    init(rootController: UINavigationController, useCases: UseCasesProvider) {
        self.rootController = rootController
        self.useCases = useCases
    }
    
    func start() {
        startSignIn()
    }
    
    // MARK: - Private
    
    private func startSignIn() {
        let signInVC: SignInVC = makeController(viewModel: SignInVM()) { $0.delegate = self }
        rootController.pushViewController(signInVC, animated: false)
    }
}

//MARK: - SignInVCDelegate

extension AuthCoordinator: SignInVCDelegate {
    
}
