//
//  ViewModelProtocol.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import UIKit

protocol ViewModelProtocol: UseCasesConsumer {
    var coordinator: AnyCoordinatorProtocol { get set }
}

private enum ViewModelProtocolKeys {
    static var coordinator = "coordinator"
}

extension ViewModelProtocol {
    var coordinator: AnyCoordinatorProtocol {
        get {
            if let coordinator: AnyObject = ObjcRuntime.getAssociatedObject(
                object: self,
                key: &ViewModelProtocolKeys.coordinator) {
                return coordinator as! AnyCoordinatorProtocol
            } else { fatalError("useCases are required for \(Self.self)") }
        }
        
        set {
            ObjcRuntime.setAssociatedObject(object: self,
                                            value: newValue,
                                            key: &ViewModelProtocolKeys.coordinator,
                                            policy: .retain)
        }
    }
}

extension UIViewController {
    static var describing: String {
        return String(describing: `self`)
    }
    
    func setCoordinator<C: CoordinatorProtocol>(_ coordinator: C) {
        setAssociatedObject(value: coordinator,
                            key: ViewModelProtocolKeys.coordinator,
                            policy: .retainNonatomic)
    }
}
