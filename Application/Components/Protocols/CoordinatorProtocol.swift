//
//  CoordinatorProtocol.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyCoordinatorProtocol {
    associatedtype RootController: UIViewController

    var rootController: RootController { get }
    var useCases: UseCasesProvider { get }
}

extension CoordinatorProtocol {
    
    func makeController<T: UIViewController & Makeable & ViewModelContainer>(viewModel: T.ViewModel, _ builder: T.Builder) -> T
        
        where T.Value == T {
            
            guard let useCases = useCases as? T.ViewModel.UseCases else {
                fatalError("V.UseCases should be subset of Coordinator.UseCasesProvider")
            }
            
            let controller: T = T.make(builder)
            controller.viewModel = viewModel
            controller.viewModel.coordinator = self
            controller.viewModel.useCases = useCases
            return controller
    }
}
