//
//  UseCasesConsumer.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

protocol UseCasesConsumer: class {
    associatedtype UseCases
    
    var useCases: UseCases { get }
    func useCaseDidAssigned()
}

private enum UseCasesConsumerKeys {
    static var useCases = "useCases"
}

extension UseCasesConsumer {
    func useCaseDidAssigned() {
        
    }
    
    var useCases: UseCases {
        get {
            if let useCases: UseCases = ObjcRuntime.getAssociatedObject(
                object: self,
                key: &UseCasesConsumerKeys.useCases) {
                return useCases
            } else { fatalError("useCases are required for \(Self.self)") }
        }
        
        set {
            ObjcRuntime.setAssociatedObject(object: self,
                                            value: newValue,
                                            key: &UseCasesConsumerKeys.useCases,
                                            policy: .retain)
            useCaseDidAssigned()
        }
    }
}
