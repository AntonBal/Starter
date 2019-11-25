//
//  AppCoordinator.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import UIKit
import ReactiveSwift

final class ApplicationCoordinator: CoordinatorProtocol {
    typealias RootController = UINavigationController
    
    enum Flow {
        case none
        case auth(AuthCoordinator)
        case main(MainCoordinator)
    }
    
    // MARK: - Properties
    
    let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    let useCases: UseCasesProvider
    let rootController: RootController
    
    private let flow: MutableProperty<Flow> = .init(.none)
    
    // MARK: - Setup
    
    init(useCases: UseCasesProvider) {
        self.useCases = useCases
        self.rootController = UINavigationController()
        setupFlow()
    }
    
    // MARK: - Private
    
    private func setupFlow() {
        subscribeFlow()
        
        let authUser = useCases.session.authorizedUser.ignoreError()
        let loginUser = useCases.session.didLogin.ignoreError()
        let logoutUser = useCases.session.didLogout.map(value: Optional<User>.none)

        let currentFlow = authUser
            .merge(with: loginUser)
            .merge(with: logoutUser)
            .map { [weak self] user -> Flow in
                guard let self = self else { return .none }

                switch user {
                case .some:
                    return .main(MainCoordinator(rootController: UINavigationController(), useCases: self.useCases))
                case .none:
                    return .auth(AuthCoordinator(rootController: UINavigationController(), useCases: self.useCases))
                }
        }

        flow <~ currentFlow
    }
    
    private func subscribeFlow() {
        flow
            .producer
            .startWithValues { [weak  self] flow in
                guard let self = self else { return }
                
                switch flow {
                case .none: return
                case .auth(let coordinator):
                    self.show(controller: coordinator.rootController)
                    coordinator.start()
                case .main(let coordinator):
                    self.show(controller: coordinator.rootController)
                    coordinator.start()
                }
        }
    }
    
    private func show(controller: UIViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
